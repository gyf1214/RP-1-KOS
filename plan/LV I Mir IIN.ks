@lazyGlobal off.

print "Mir IIN Orbit Profile for SR IVA Series".
loadModule("orbitTwoStages.ks").

orbitTwoStages(1.45, 129.2, 75.0, 800000, 15).
print "release satellite".
stage.
