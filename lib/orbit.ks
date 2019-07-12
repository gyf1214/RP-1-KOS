@lazyGlobal off.

loadModule("launchOneStage.ks").

function finalStage {
    parameter finalTime is 0.0.
    parameter rcsTime is 2.5.
    parameter rcsKillTime is 5.

    print "deploy final stage".
    stage.

    set ship:control:mainthrottle to 0.
    rcs on.
    lock steering to "kill".
    wait rcsKillTime.


    wait until ETA:apoapsis <= rcsTime + finalTime / 2.0 or ETA:periapsis < ETA:apoapsis.
    print "rcs propel".
    set ship:control:fore to 1.0.
    set ship:control:mainthrottle to 1.
    wait rcsTime.

    print "ignite engine".
    lock steering to dirZZ(ship:facing, ship:prograde:forevector).
    stage.
    set ship:control:fore to 0.0.
    rcs off.
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

function doFinalStage {
    parameter finalTime is 0.0.
    parameter minAP is 140000.

    wait until ship:maxthrust = 0.
    finalStage(finalTime).
    waitForOrbit(minAP).
    MECO().
}

function deployFairing {
    print "deploy fairing".
    stage.
    lock steering to dirZZ(ship:facing, ship:prograde:forevector).
}

print "orbit v0.2.0 loaded".
