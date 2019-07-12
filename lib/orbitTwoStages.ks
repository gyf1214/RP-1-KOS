@lazyGlobal off.

loadModule("orbit.ks").

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

print "orbitTwoStages v0.1.0 loaded".
