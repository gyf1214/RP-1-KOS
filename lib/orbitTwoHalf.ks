@lazyGlobal off.

loadModule("orbit.ks").

function orbitTwoHalf {
    parameter offset is 0.0.
    parameter finalTime is 0.0.
    parameter turnStart is 60.0.
    parameter minAP is 140000.
    parameter azimuth is 90.0.

    doLaunchOneStage(offset, turnStart, azimuth).

    local booster is ship:partsTagged("booster")[0].
    when booster:maxThrust = 0 then {
        print "booster flame out".
        wait 1.5.
        print "decouple booster".
        stage.
    }

    when ship:altitude > 70000 then {
        deployFairing().
    }

    doFinalStage(finalTime, minAP).
}

print "orbitTwoHalf v0.1.0 loaded".
