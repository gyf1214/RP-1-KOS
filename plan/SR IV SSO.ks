@lazyGlobal off.

print "SSO Orbit Profile for SR IV Series".
loadModule("orbit.ks").

orbitThreeStages(0.8, 92.2, 60.0, 180000, 200).
print "release satellite".
stage.
