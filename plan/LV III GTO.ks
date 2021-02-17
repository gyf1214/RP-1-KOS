@lazyGlobal off.

print "GTO Orbit Profile for LV II Series".
loadModule("booster.ks").
loadModule("orbitTwoStages.ks").

addBoosterTag().
orbitTwoStages(0.2, 422.0, 65.0, 350000000, 160).
print "release satellite".
stage.
