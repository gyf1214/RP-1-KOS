@lazyGlobal off.

print "Profile for SR IIH Series".
loadModule("launchOneStage.ks").

when ship:altitude > 70000 then {
    print "deploy fairing".
    stage.
}

launchOneStage(2.0).

wait until ship:altitude > 140000.
print "release spacecraft".
stage.
wait until ship:altitude < 140000 and ship:airspeed < 340.
print "arm chutes".
stage.
