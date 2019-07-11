@lazyGlobal off.

print "Orbit Profile for LV I Series".
loadModule("orbit.ks").

orbitTwoStages(1.75, 127.9, 65.0, 180000).
print "release satellite".
stage.
