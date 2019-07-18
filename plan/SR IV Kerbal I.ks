@lazyGlobal off.

print "Kerbal I Suborbit Return Profile for SR IV Series".
loadModule("orbitThreeStages.ks").

orbitThreeStages(0.8, 92.2, 55.0, 0).
print "release satellite".
stage.
wait until ship:altitude < 140000.
print "reentry start".
rcs on.
wait until ship:altitude < 100000.
rcs off.
wait until ship:airspeed < 340.
print "arm chutes".
stage.
wait until ship:airspeed < 10.
stage.
