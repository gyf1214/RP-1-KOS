@lazyGlobal off.

loadModule("booster.ks").
loadModule("orbitTwoStages.ks").

function orbitTwoHalf {
    parameter offset is 0.0.
    parameter finalTime is 0.0.
    parameter turnStart is 60.0.
    parameter minAP is 140000.
    parameter azimuth is 90.0.

    addBoosterTag().
    orbitTwoStages(offset, finalTime, turnStart, minAP, azimuth).
}

print "orbitTwoHalf v0.2.0 loaded".
