@lazyGlobal off.

loadModule("nav.ks").
loadModule("vessel.ks").

function decouplePart {
    parameter part.
    local modules is list("ModuleDecouple", "ModuleAnchoredDecoupler").
    for module in modules {
        if part:hasModule(module) {
            part:getmodule(module):doEvent("decouple").
        }
    }
}

function registerBooster {
    parameter coreStageInfo.
    parameter booster.

    local me is booster:engine.
    when me:thrust < 0.1 * me:possiblethrust then {
        logPrint("booster: " + me:name + " flameout").
        logPrint("thrust: " + me:thrust + " / " + me:possiblethrust).
        me:shutdown().
        logPrint("decouple booster: " + me:name).
        decouplePart(booster:decoupler).
        set coreStageInfo:remainBoosters to coreStageInfo:remainBoosters - 1.
        logPrint("remain " + coreStageInfo:remainBoosters + " boosters").
    }
}

function autoBoosters {
    parameter coreStageInfo.

    coreStageInfo:add("remainBoosters", coreStageInfo:boosters:length).
    logPrint("total " + coreStageInfo:boosters:length + " boosters").
    for booster in coreStageInfo:boosters {
        registerBooster(coreStageInfo, booster).
    }
}

function checkEngineIgnition {
    parameter engine.
    if stage:number <= engine:stage and engine:thrust < 0.5 * engine:possiblethrust {
        logPrint("warning: engine " + engine:name + " ignition failed").
        return false.
    }
    return true.
}

function checkIgnition {
    parameter coreStageInfo.

    for engine in coreStageInfo:coreEngines {
        if not checkEngineIgnition(engine) {
            return false.
        }
    }
    for booster in coreStageInfo:boosters {
        if not checkEngineIgnition(booster:engine) {
            return false.
        }
    }
    return true.
}

function doLaunchOneStage {
    parameter offset is 0.0.
    parameter turnStart is 60.0.
    parameter azimuth is 90.0.

    local coreStageInfo is getCoreStageInfo(stage:number - 2).

    logPrint("launch for direction: " + azimuth).
    set ship:control:pilotmainthrottle to 1.0.
    local lock yy to ship:up:forevector.
    local lock zz to ship:north:forevector.
    local lock vv to ship:srfprograde:forevector.
    lock steering to dirZZ(ship:facing, yy).
    wait 1.
    logPrint("ignite engine").
    stage.
    wait 3.
    if not checkIgnition(coreStageInfo) {
        logPrint("warning: engine ignition check failed, terminate launch!").
        for engine in coreStageInfo:coreEngines {
            engine:shutdown.
        }
        for booster in coreStageInfo:boosters {
            booster:engine:shutdown.
        }
        shutdown.
    }
    stage.
    logPrint("lift off").
    wait 1.
    logPrint("register boosters").
    autoBoosters(coreStageInfo).

    wait until ship:airspeed > turnStart.
    logPrint("gravity turn with offset: " + offset).
    lock steering to dirZZ(ship:facing, pitchOffset(yy, zz, vv, azimuth, offset)).
    wait until coreStageInfo:remainBoosters <= 0.
    logPrint("all boosters decoupled").
    until stage:number <= coreStageInfo:coreStage + 1 {
        stage.
        wait 1.
    }
}

function MECO {
    set ship:control:pilotmainthrottle to 0.
    unlock steering.
    logPrint("MECO").
    wait 1.0.
}

function deployPayload {
    logPrint("deploy payload").
    stage.
    wait 1.
    reportOrbit().
}

function deployFairing {
    logPrint("deploy fairing").
    local fairings is getAllFairings().
    for part in fairings {
        part:getModule("ProceduralFairingDecoupler"):doevent("jettison fairing").
    }
    lock steering to dirZZ(ship:facing, ship:prograde:forevector).
}

function autoFairing {
    parameter fairingHeight is 70000.
    when ship:altitude >= fairingHeight then {
        deployFairing().
    }
}

function launchOneStage {
    parameter offset is 0.0.
    parameter turnStart is 60.0.
    parameter azimuth is 90.0.

    doLaunchOneStage(offset, turnStart, azimuth).

    wait until ship:maxThrust = 0.
    MECO().
}

logPrint("launchOneStage v0.1.9 loaded").
