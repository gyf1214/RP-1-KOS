@lazyGlobal off.

print "Mir IIC Orbit Profile for LV IA Series".
loadModule("orbitTwoHalfFix.ks").

orbitTwoHalfFix(0.13, 31, 143.0, 85.0, 300000, 158).
print "release satellite".
stage.
