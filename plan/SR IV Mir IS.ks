@lazyGlobal off.

print "Mir IS Orbit Profile for SR IV Series".
loadModule("orbit.ks").

orbitThreeStages(1.5, 92.2, 75.0, 1500000).
print "release satellite".
stage.
