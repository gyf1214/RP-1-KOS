@lazyGlobal off.

loadModule("nav.ks").

function doLaunchOneStage {
    parameter offset is 0.0.
    parameter turnStart is 60.0.
    parameter azimuth is 90.0.

    print "launch for direction: " + azimuth.
    set ship:control:mainthrottle to 1.0.
    local lock yy to ship:up:forevector.
    local lock zz to ship:north:forevector.
    local lock vv to ship:srfprograde:forevector.
    lock steering to dirZZ(ship:facing, yy).
    wait 1.
    print "ignite engine".
    stage.
    wait 3.
    stage.
    print "lift off".

    wait until ship:airspeed > turnStart.
    print "gravity turn with offset: " + offset.
    lock steering to dirZZ(ship:facing, pitchOffset(yy, zz, vv, azimuth, offset)).
}

function MECO {
    set ship:control:mainthrottle to 0.
    unlock steering.
    print "MECO".
    wait 1.0.
}

function launchOneStage {
    parameter offset is 0.0.
    parameter turnStart is 60.0.
    parameter azimuth is 90.0.

    doLaunchOneStage(offset, turnStart, azimuth).

    wait until ship:maxThrust = 0.
    MECO().
}

print "launchOneStage v0.1.2 loaded".
