@lazyGlobal off.

print "X-1 Profile for SR II Series".
loadModule("launchOneStage.ks").

launchOneStage(2.0).

wait until ship:altitude > 140000.
print "release spacecraft".
stage.
wait until ship:altitude < 140000 and ship:airspeed < 340.
print "arm chutes".
stage.
