@lazyGlobal off.

loadModule("nav.ks").

function doLaunchOneStage {
    parameter offset is 0.0.
    parameter turnStart is 60.0.
    parameter azimuth is 90.0.

    logPrint("launch for direction: " + azimuth).
    set ship:control:pilotmainthrottle to 1.0.
    local lock yy to ship:up:forevector.
    local lock zz to ship:north:forevector.
    local lock vv to ship:srfprograde:forevector.
    lock steering to dirZZ(ship:facing, yy).
    wait 1.
    logPrint("ignite engine").
    stage.
    wait 3.
    stage.
    logPrint("lift off").

    wait until ship:airspeed > turnStart.
    logPrint("gravity turn with offset: " + offset).
    lock steering to dirZZ(ship:facing, pitchOffset(yy, zz, vv, azimuth, offset)).
}

function MECO {
    set ship:control:pilotmainthrottle to 0.
    unlock steering.
    logPrint("MECO").
    wait 1.0.
}

function deployFairing {
    logPrint("deploy fairing").
    stage.
    lock steering to dirZZ(ship:facing, ship:prograde:forevector).
}

function launchOneStage {
    parameter offset is 0.0.
    parameter turnStart is 60.0.
    parameter azimuth is 90.0.

    doLaunchOneStage(offset, turnStart, azimuth).

    wait until ship:maxThrust = 0.
    MECO().
}

logPrint("launchOneStage v0.1.3 loaded").
