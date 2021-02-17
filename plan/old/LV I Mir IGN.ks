@lazyGlobal off.

print "Mir IGN Orbit Profile for LV I Series".
loadModule("orbitTwoStages.ks").

orbitTwoStages(1.6, 129.2, 65.0, 400000, 43).
print "release satellite".
stage.
