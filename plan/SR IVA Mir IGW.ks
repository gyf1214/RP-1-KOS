@lazyGlobal off.

print "Mir IGW Orbit Profile for SR IVA Series".
loadModule("orbit.ks").

orbitThreeStages(1.3, 120.2, 75.0, 630000).
print "release satellite".
stage.
