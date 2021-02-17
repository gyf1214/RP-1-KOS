@lazyGlobal off.

print "2nd Gen Nav Orbit Profile for LV III Series".
loadModule("orbitTwoHalf.ks").

orbitTwoHalf(0.3, 442.0, 65.0, 9e5, 177).
print "release satellite".
stage.
