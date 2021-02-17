@lazyGlobal off.

print "2nd Gen Weather Orbit Profile for LV III Series".
loadModule("orbitTwoHalf.ks").

orbitTwoHalf(0.3, 442.0, 65.0, 1e6, 207).
print "release satellite".
stage.
