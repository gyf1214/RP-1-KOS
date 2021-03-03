@lazyGlobal off.

loadModule("launchOneStage.ks").
loadModule("maneuver.ks").

function doLaunchNStages {
    parameter N is 2.
    parameter offset is 0.0.
    parameter turnStart is 60.0.
    parameter azimuth is 90.0.
    parameter sepTime is 0.7.
    parameter fairingHeight is 70000.

    doLaunchOneStage(offset, turnStart, azimuth).

    when ship:altitude > fairingHeight then {
        deployFairing().
    }

    from { local i is 1. } until i >= N step { set i to i + 1. } do {
        wait until ship:maxThrust = 0.
        logPrint("separate stage " + i).
        stage.
        wait sepTime.
        logPrint("ignite engine").
        stage.
        // this is to prevent ship:maxThrust is zero instantly
        wait sepTime.
    }
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
    parameter sepTime is 0.7.

    logPrint("lock to maneuver direction").
    set ship:control:pilotmainthrottle to 0.0.
    rcs on.
    lock steering to orbitVelAtTA(180):normalized.

    local totalTime is 0.
    local N is 0.
    for sta in stages {
        if finalTime > 0 and totalTime >= finalTime {
            break.
        }
        set N to N + 1.
        set totalTime to totalTime + sepTime + sta:burntime.
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

    logPrint("wait until burn time, ETA " + waitTime).
    if waitTime > 0 {
        wait waitTime.
    }

    local stopTime is 0.
    from { local i is 1. } until i > N step { set i to i + 1. } do {
        logPrint("deploy final stage " + i).
        stage.
        set ship:control:pilotmainthrottle to 1.0.
        wait sepTime.
        logPrint("ignite engine").
        stage.
        if i = N {
            set stopTime to time:seconds + finalTime - sepTime.
            wait sepTime.
            wait until ship:maxthrust = 0 or stopCondition:call(stopTime).
        } else {
            wait sepTime.
            wait until ship:maxthrust = 0.
            set finalTime to finalTime - stages[i - 1]:burntime - sepTime.
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

    local stopCondition is {
        parameter stopTime.
        return ship:orbit:apoapsis >= targetAlt.
    }.
    if curAP > targetAlt {
        set stopCondition to {
            parameter stopTime.
            return ship:orbit:periapsis >= targetAlt.
        }.
    }

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
