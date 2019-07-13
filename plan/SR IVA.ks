@lazyGlobal off.

print "Orbit Profile for SR IVA Series".
loadModule("orbitThreeStages.ks").

orbitThreeStages(1.5, 125.0, 75.0, 180000).
print "release satellite".
stage.
