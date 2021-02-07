@lazyGlobal off.

loadModule("booster.ks").
loadModule("orbitTwoStages.ks").

function orbitTwoHalfFix {
    parameter offset is 0.0.
    parameter boostTime is 0.0.
    parameter finalTime is 0.0.
    parameter turnStart is 60.0.
    parameter minAP is 140000.
    parameter azimuth is 90.0.

    addBoosterTimeout(boostTime).
    orbitTwoStages(offset, finalTime, turnStart, minAP, azimuth).
}

print "orbitTwoHalfFix v0.1.0 loaded".
