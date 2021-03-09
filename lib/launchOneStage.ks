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

function deployPayload {
    logPrint("deploy payload").
    stage.
    wait 1.
    reportOrbit().
}

function shipStable {
    parameter desiredFore is ship:facing:forevector.

    local fore is ship:facing:forevector:normalized.
    return vAng(fore, desiredFore) < 0.2 and
           (ship:angularVel - vDot(ship:angularVel, fore) * fore):mag < 2e-4.
}

function warpWait {
    parameter waitTime is 0.
    parameter desiredFore is ship:facing:forevector.
    parameter graceTime is 15.

    logPrint("warp wait: " + waitTime + "s").
    local now is time:seconds.
    local stopTime is now + waitTime.
    wait until time:seconds >= stopTime or shipStable(desiredFore).
    set kuniverse:timewarp:rate to 1.
    set kuniverse:timewarp:mode to "RAILS".
    if stopTime - time:seconds > graceTime {
        kuniverse:timewarp:warpto(stopTime - graceTime).
    }
    wait until time:seconds >= stopTime.
}

function postFairing {
    lock steering to dirZZ(ship:facing, ship:prograde:forevector).
}

function deployFairing {
    logPrint("deploy fairing").
    local fairings is getAllFairings().
    for part in fairings {
        part:getModule("ProceduralFairingDecoupler"):doevent("jettison fairing").
    }
    postFairing().
}

function autoFairing {
    parameter fairingHeight is 70000.
    if ship:altitude < fairingHeight {
        when ship:altitude >= fairingHeight then {
            deployFairing().
        }
    } else {
        postFairing().
    }
}

function launchOneStage {
    parameter offset is 0.0.
    parameter turnStart is 60.0.
    parameter azimuth is 90.0.

    doLaunchOneStage(offset, turnStart, azimuth).

    wait until ship:maxThrust = 0.
    MECO().
}

logPrint("launchOneStage v0.1.4 loaded").
