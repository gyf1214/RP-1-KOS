@lazyGlobal off.

print "Orbit Profile for SR IVA Series".
loadModule("orbit.ks").

orbitThreeStages(1.5, 120.2, 75.0, 180000).
print "release satellite".
stage.
