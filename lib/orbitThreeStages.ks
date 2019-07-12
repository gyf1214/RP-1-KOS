@lazyGlobal off.

loadModule("orbit.ks").

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

print "orbitThreeStages v0.1.0 loaded".
