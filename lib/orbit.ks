@lazyGlobal off.

loadModule("launchOneStage.ks").
loadModule("maneuver.ks").
loadModule("vessel.ks").

function postFairing {
    lock steering to dirZZ(ship:facing, ship:prograde:forevector).
}

function deployFairing {
    logPrint("deploy fairing").
    local fairings is getAllFairings().
    for part in fairings {
        part:getModule("ProceduralFairingDecoupler"):doevent("jettison fairing").
    }
    postFairing().
}

function autoFairing {
    parameter fairingHeight is 70000.
    if ship:altitude < fairingHeight {
        when ship:altitude >= fairingHeight then {
            deployFairing().
        }
    } else {
        postFairing().
    }
}

function separateNStages {
    parameter N.
    parameter startStage is 0.
    parameter fairingHeight is 70000.

    local sepTime is 0.7.
    local waitmargin is 0.7.

    autoFairing(fairingHeight).

    from { local i is 1. } until i > N step { set i to i + 1. } do {
        wait until ship:maxThrust = 0.
        logPrint("separate stage " + (startStage + i)).
        stage.
        wait sepTime.
        logPrint("ignite engine").
        stage.
        // this is to prevent ship:maxThrust is zero instantly
        wait waitmargin.
    }
}

function doLaunchNStages {
    parameter N.
    parameter offset is 0.0.
    parameter turnStart is 60.0.
    parameter azimuth is 90.0.
    parameter fairingHeight is 70000.

    doLaunchOneStage(offset, turnStart, azimuth).
    separateNStages(N - 1, 1, fairingHeight).
}

function deployPayload {
    logPrint("deploy payload").
    stage.
    wait 1.
    reportOrbit().
}

function finalNStages {
    parameter stages is list().
    parameter finalTime is 0.
    parameter stopCondition is {
        parameter stopTime.
        return time:seconds >= stopTime.
    }.
    local waitmargin is 0.7.

    logPrint("lock to maneuver direction").
    set ship:control:pilotmainthrottle to 0.0.
    rcs on.
    local prograd is orbitVelAtTA(180):normalized.
    lock steering to dirZZ(ship:facing, prograd).

    local totalTime is 0.
    local N is 0.
    for sta in stages {
        if finalTime > 0 and totalTime >= finalTime {
            break.
        }
        set N to N + 1.
        set totalTime to totalTime + sta:septime + sta:burntime.
    }

    if finalTime <= 0 or finalTime > totalTime {
        set finalTime to totalTime.
        set stopCondition to {
            parameter stopTime.
            return ship:maxthrust = 0.
        }.
        logPrint("set final time to " + finalTime).
    }

    if N < stages:length {
        logPrint("warning: use " + N + "/" + stages:length + " stages").
    }

    logPrint("final " + N + " stages, total time " + finalTime).
    local waitTime is ETA:apoapsis - finalTime / 2.

    if not stages[0]:hasmotor {
        logPrint("deploy final stage 1").
        stage.
    }

    logPrint("wait until burn time, ETA " + waitTime).
    if waitTime > 0 {
        wait waitTime.
    }

    local stopTime is 0.
    from { local i is 1. } until i > N step { set i to i + 1. } do {
        local sta is stages[i - 1].

        if i <> 1 or sta:hasmotor {
            logPrint("deploy final stage " + i).
            stage.
        }
        if not sta:hasmotor {
            logPrint("rcs propel").
            rcs on.
            set ship:control:fore to 1.0.
        }
        set ship:control:pilotmainthrottle to 1.0.
        wait sta:septime.
        logPrint("ignite engine").
        stage.
        set ship:control:fore to 0.0.
        if i = N {
            set stopTime to time:seconds + finalTime - waitmargin.
            wait waitmargin.
            wait until ship:maxthrust = 0 or stopCondition:call(stopTime).
        } else {
            wait waitmargin.
            wait until ship:maxthrust = 0.
            set finalTime to finalTime - sta:burntime - sta:septime.
        }
    }
    MECO().
    wait 1.
    deployPayload().
    if not stopCondition:call(stopTime) {
        logPrint("warning: maybe not in correct orbit").
    }
}

function targetOrbitAlt {
    parameter stages is list().
    parameter targetAlt is 140000.

    local curAP is ship:orbit:apoapsis.
    logPrint("current AP: " + curAP + ", target Alt: " + targetAlt).

    local dv is dvChangeAPPE(targetAlt).
    logPrint("circularize dv: " + dv).

    local finalTime is multiStagesBurntime(dv, stages).
    logPrint("set burntime to " + finalTime).

    local R is ship:orbit:body:radius.
    local stopCondition is {
        parameter stopTime.
        return ship:orbit:semimajoraxis >= R + (curAP + targetAlt) / 2.
    }.

    finalNStages(stages, finalTime, stopCondition).
}

function targetOrbitEcc {
    parameter stages is list().
    parameter ecc is 0.
    parameter minPE is 140000.
    
    local R is ship:orbit:body:radius.
    local minAP is (minPE + R) / (1 - ecc) * (1 + ecc) - R.
    local curAP is ship:orbit:apoapsis.
    local targetAlt is 0.
    if curAP < minAP {
        if curAP < minPE {
            logPrint("warning: minimal PE " + minPE + " needed, current AP: " + curAP).
        }
        set targetAlt to (curAP + R) / (1 - ecc) * (1 + ecc) - R.
    } else {
        set targetAlt to (curAP + R) / (1 + ecc) * (1 - ecc) - R.
    }
    logPrint("target Ecc: " + ecc).
    targetOrbitAlt(stages, targetAlt).
}

function targetOrbitAPPE {
    parameter stages is list().
    parameter minAP is 140000.
    parameter minPE is 140000.

    local targetAlt is 0.
    local curAP is ship:orbit:apoapsis.

    if curAP < minAP {
        if curAP < minPE {
            logPrint("warning: minimal PE " + minPE + " needed, current AP: " + curAP).
        }
        set targetAlt to minAP.
    } else {
        set targetAlt to minPE.
    }
    targetOrbitAlt(stages, targetAlt).
}

logPrint("orbit v0.5.0 loaded").
