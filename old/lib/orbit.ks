@lazyGlobal off.

loadModule("launchOneStage.ks").

function warpWait {
    parameter waitTime is 0.
    parameter graceTime is 5.
    
    print "warp wait: " + waitTime + "s".
    local now is time:seconds.
    if waitTime > graceTime {
        kuniverse:timewarp:warpto(time:seconds + waitTime - graceTime).
    }
    local waitTime is now + waitTime - time:seconds.
    print "warp finished, wait: " + waitTime.
    wait waitTime.
}

function stageFinalStage {
    parameter rcsTime is 2.5.
    
    print "rcs propel".
    rcs on.
    set ship:control:fore to 1.0.
    set ship:control:pilotmainthrottle to 1.
    wait rcsTime.

    print "ignite engine".
    lock steering to dirZZ(ship:facing, ship:prograde:forevector).
    stage.
    set ship:control:fore to 0.0.
    rcs off.
}

function finalStage {
    parameter finalTime is 0.0.
    parameter rcsTime is 2.5.
    parameter rcsKillTime is 5.

    print "deploy final stage".
    stage.

    set ship:control:pilotmainthrottle to 0.
    rcs on.
    lock steering to "kill".

    if ETA:apoapsis > rcsTime + finalTime / 2.0 + rcsKillTime {
        wait rcsKillTime.
        print "rcs off".
        rcs off.
    }

    if ETA:periapsis > ETA:apoapsis {
        warpWait(ETA:apoapsis - rcsTime - finalTime / 2.0).
    }

    stageFinalStage(rcsTime).
}

function waitForOrbit {
    parameter minAP is 140000.
    parameter minPE is 140000.

    if ship:obt:apoapsis > minAP {
        wait until ship:obt:periapsis > minAP or ship:maxthrust = 0.
    } else {
        wait until (ship:obt:apoapsis > minAP and ship:obt:periapsis > minPE) or ship:maxthrust = 0.
    }
}

function waitForSubOrbit {
    parameter minAP is 140000.
    wait until ship:obt:apoapsis > minAP or ship:maxthrust = 0.
}

function doFinalStage {
    parameter finalTime is 0.0.
    parameter minAP is 140000.

    wait until ship:maxthrust = 0.
    finalStage(finalTime).
    waitForOrbit(minAP).
    MECO().
}

function doFinalStageSub {
    parameter minAP is 140000.

    wait until ship:maxthrust = 0.
    print "deploy final stage".
    stage.
    lock steering to "kill".

    stageFinalStage().
    waitForSubOrbit(minAP).
    MECO().
}



print "orbit v0.3.0 loaded".
