@lazyGlobal off.

global g0 is 9.80655.

function getThrustTime {
    parameter dv, thrust, isp, mass.

    local ratio is constant:e ^ (dv / isp / g0).
    local throw is mass * (1 - 1 / ratio).
    return throw * isp * g0 / thrust.
}

function getVelocity {
    parameter a0, a1.
    parameter bd is ship:body.

    local r0 is bd:radius + a0.
    local r1 is bd:radius + a1.
    local L is sqrt(2 * constant:G * bd:mass / (1 / r0 + 1 / r1)).
    return L / r0.
}

function raiseAP {
    parameter tarAP.
    parameter ves is ship.

    local v0 is getVelocity(ves:periapsis, ves:apoapsis, ves:body).
    local v1 is getVelocity(ves:periapsis, tarAP, ves:body).
    return v1 - v0.
}

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

local dv is raiseAP(400000).
print dv.
local dt is getThrustTime(dv, 4 * 0.0239, 198, ship:mass).

kuniverse:timeWarp:warpto(time:seconds + eta:periapsis - dt / 2 - 15).
wait eta:periapsis - dt / 2 - 15.
print "1".
rcs on.
lock steering to dirZZ(ship:facing, ship:prograde:forevector).
wait 15.
print "2".
set ship:control:pilotmainthrottle to 1.0.
set ship:control:fore to 1.0.
wait dt.
print "3".
set ship:control:pilotmainthrottle to 0.0.
set ship:control:fore to 0.0.
unlock steering.
