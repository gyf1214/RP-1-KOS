@lazyGlobal off.

print "Mir IGW Orbit Profile for SR IVA Series".
loadModule("orbitThreeStages.ks").

orbitThreeStages(1.2, 129.3, 75.0, 630000).
print "release satellite".
stage.
