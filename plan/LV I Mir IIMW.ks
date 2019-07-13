@lazyGlobal off.

print "Mir IIW Orbit Profile for LV I Series".
loadModule("orbitTwoStages.ks").

orbitTwoStages(1.65, 129.2, 65.0, 300000).
print "release satellite".
stage.
