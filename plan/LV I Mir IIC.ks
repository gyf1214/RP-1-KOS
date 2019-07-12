@lazyGlobal off.

print "Mir IGC Orbit Profile for LV I Series".
loadModule("orbitTwoStages.ks").

orbitTwoStages(1.3, 129.2, 65.0, 4500000, 55).
print "release satellite".
stage.
