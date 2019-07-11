@lazyGlobal off.

print "Mir IG Orbit Profile for SR IVA Series".
loadModule("orbit.ks").

orbitThreeStages(1.3, 120.2, 75.0, 300000).
print "release satellite".
stage.
