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

logPrint("nav v0.1.2 loaded").
