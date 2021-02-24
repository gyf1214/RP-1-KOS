@lazyGlobal off.

print "Mir IIMW2 Orbit Profile for LV I Series".
loadModule("orbitTwoStages.ks").

orbitTwoStages(1.55, 129.2, 65.0, 650000, 40).
print "release satellite".
stage.
