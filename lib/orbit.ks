@lazyGlobal off.

loadModule("launchOneStage.ks").
loadModule("maneuver.ks").

function doLaunchNStages {
    parameter N is 2.
    parameter offset is 0.0.
    parameter turnStart is 60.0.
    parameter azimuth is 90.0.
    parameter sepTime is 0.6.
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
    MECO().
    logPrint("deploy payload").
    stage.
    reportOrbit().
}

function finalNStages {
    parameter burntimes is list().
    parameter sepTime is 0.6.

    logPrint("lock to maneuver direction").
    set ship:control:pilotmainthrottle to 0.0.
    rcs on.
    lock steering to orbitVelAtTA(180):normalized.

    local finalTime is 0.
    for t in burntimes {
        set finalTime to finalTime + sepTime + t.
    }
    local N is burntimes:length.

    logPrint("final " + N + " stages, total time " + finalTime).
    local waitTime is ETA:apoapsis - finalTime / 2.

    logPrint("wait until burn time, ETA " + waitTime).
    if waitTime > 0 {
        wait waitTime.
    }

    from { local i is 0. } until i >= N step { set i to i + 1. } do {
        logPrint("deploy final stage " + (i + 1)).
        stage.
        set ship:control:pilotmainthrottle to 1.0.
        wait sepTime.
        logPrint("ignite engine").
        stage.
        wait sepTime.
        wait until ship:maxthrust = 0.
    }
    deployPayload().
}

logPrint("orbit v0.3.0 loaded").
