@lazyGlobal off.

print "Polar Orbit Profile for SR IV Series".
loadModule("orbit.ks").

orbitThreeStages(0.8, 92.2, 60.0, 180000, 190).
print "release satellite".
stage.
