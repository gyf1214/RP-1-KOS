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

function shipStable {
    parameter desiredFore is ship:facing:forevector.

    local fore is ship:facing:forevector:normalized.
    return vAng(fore, desiredFore) < 0.2 and
           (ship:angularVel - vDot(ship:angularVel, fore) * fore):mag < 2e-4.
}

function warpWait {
    parameter waitTime is 0.
    parameter desiredFore is ship:facing:forevector.
    parameter graceTime is 15.

    logPrint("warp wait: " + waitTime + "s").
    local now is time:seconds.
    local stopTime is now + waitTime.
    local preStopTime is stopTime - graceTime.
    set kuniverse:timewarp:rate to 2.
    set kuniverse:timewarp:mode to "PHYSICS".
    wait until time:seconds >= preStopTime or (shipStable(desiredFore) and ship:altitude > 140000).
    set kuniverse:timewarp:rate to 1.
    set kuniverse:timewarp:mode to "RAILS".
    if time:seconds < preStopTime {
        kuniverse:timewarp:warpto(preStopTime).
    }
    wait until time:seconds >= stopTime.
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

logPrint("launchOneStage v0.1.6 loaded").
