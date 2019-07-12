@lazyGlobal off.

print "Orbit Profile for SR IV Series".
loadModule("orbitThreeStages.ks").

orbitThreeStages(1.5, 92.2, 75.0, 300000).
print "release satellite".
stage.
