@lazyGlobal off.

loadModule("launchOneStage.ks").

function finalStage {
    parameter finalTime is 0.0.
    parameter rcsTime is 2.5.

    print "deploy final stage".
    stage.

    set ship:control:mainthrottle to 0.
    rcs on.
    lock steering to "kill".

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

function orbitThreeStages {
    parameter offset is 0.0.
    parameter finalTime is 0.0.
    parameter turnStart is 60.0.
    parameter minAP is 140000.
    parameter azimuth is 90.0.
    parameter separateTime is 0.7.

    doLaunchOneStage(offset, turnStart, azimuth).

    wait until ship:maxThrust = 0.
    print "deploy second stage".
    stage.
    wait separateTime.
    print "ignite engine".
    stage.

    wait until ship:altitude > 70000.
    deployFairing().

    doFinalStage(finalTime, minAP).
}

function orbitTwoStages {
    parameter offset is 0.0.
    parameter finalTime is 0.0.
    parameter turnStart is 60.0.
    parameter minAP is 140000.
    parameter azimuth is 90.0.

    when ship:altitude > 70000 then {
        deployFairing().
    }

    doLaunchOneStage(offset, turnStart, azimuth).
    doFinalStage(finalTime, minAP).
}

print "orbit v0.1.5 loaded".
