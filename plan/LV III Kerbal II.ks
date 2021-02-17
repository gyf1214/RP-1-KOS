@lazyGlobal off.

print "Kerbal II Orbit Profile for LV III Series".
loadModule("orbitTwoHalf.ks").

orbitTwoHalf(0.3, 442.0, 65.0, 3e5, 207).
print "release satellite".
stage.
