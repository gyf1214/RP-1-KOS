@lazyGlobal off.

loadModule("orbit.ks").

function orbitTwoHalfFix {
    parameter offset is 0.0.
    parameter boostTime is 0.0.
    parameter finalTime is 0.0.
    parameter turnStart is 60.0.
    parameter minAP is 140000.
    parameter azimuth is 90.0.

    local deployTime is time:seconds + boostTime + 4.

    when time:seconds > deployTime then {
        print "decouple booster".
        stage.
    }

    doLaunchOneStage(offset, turnStart, azimuth).

    when ship:altitude > 70000 then {
        deployFairing().
    }

    doFinalStage(finalTime, minAP).
}

print "orbitTwoHalfFix v0.1.0 loaded".
