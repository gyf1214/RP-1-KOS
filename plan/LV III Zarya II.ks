@lazyGlobal off.

print "Orbit Profile for LV III Series".
loadModule("orbitTwoHalf.ks").

orbitTwoHalf(0.5, 422.0, 65.0, 350000000).
print "release satellite".
stage.
