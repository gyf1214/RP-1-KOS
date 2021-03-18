@lazyGlobal off.

// rotate dir to zz, keep roll
function dirZZ {
    parameter dir, zz.

    local z is dir:forevector.
    local angle is vectorAngle(z, zz).
    if angle < 1e-3 or angle > 180 - 1e-3 {
        return dir.
    }
    local axis is vCrs(z, zz):normalized.
    return angleAxis(angle, axis) * dir.
}

function pitchOffset {
    parameter y, z, v, azimuth, offset.
    
    local x is vCrs(y, z).
    local pitch is vectorAngle(y, v).
    local axis is cos(azimuth) * x - sin(azimuth) * z.
    return angleAxis(pitch + offset, axis) * y.
}

function shipStable {
    parameter desiredFore is ship:facing:forevector.

    local fore is ship:facing:forevector:normalized.
    return vAng(fore, desiredFore) < 0.2 and
           (ship:angularVel - vDot(ship:angularVel, fore) * fore):mag < 4e-4.
}

function warpWait {
    parameter waitTime is 0.
    parameter desiredFore is ship:facing:forevector.
    parameter graceTime is 15.

    logPrint("warp wait: " + waitTime + "s").
    local now is time:seconds.
    local stopTime is now + waitTime.
    local preStopTime is stopTime - graceTime.
    set kuniverse:timewarp:mode to "PHYSICS".
    set kuniverse:timewarp:rate to 2.
    wait until time:seconds >= preStopTime or (shipStable(desiredFore) and ship:altitude > 140000).
    set kuniverse:timewarp:mode to "RAILS".
    set kuniverse:timewarp:rate to 1.
    if time:seconds < preStopTime {
        kuniverse:timewarp:warpto(preStopTime).
    }
    wait until time:seconds >= stopTime.
}

logPrint("nav v0.1.3 loaded").
