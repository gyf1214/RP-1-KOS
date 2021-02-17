@lazyGlobal off.

print "Orbit Profile for LV I Series".
loadModule("orbitTwoHalf.ks").

orbitTwoHalf(1.4, 129.2, 65.0, 350000000).
print "release satellite".
stage.
