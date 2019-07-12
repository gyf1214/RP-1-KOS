@lazyGlobal off.

print "Orbit Profile for LV I Series".
loadModule("orbitTwoStages.ks").

orbitTwoStages(1.75, 129.2, 65.0, 180000).
print "release satellite".
stage.
