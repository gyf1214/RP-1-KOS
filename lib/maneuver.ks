@lazyGlobal off.

function orbitPos {
    parameter orbi is ship:orbit.
    return orbi:position - orbi:body:position.
}

function orbitAng {
    parameter orbi is ship:orbit.
    return vCrs(orbitPos(orbi), orbi:velocity:orbit).
}

function orbitAngNorm {
    parameter orbi is ship:orbit.
    return vCrs(orbitPos(orbi), orbi:velocity:orbit):normalized.
}

function orbitGM {
    parameter orbi is ship:orbit.
    return constant:G * orbit:body:mass.
}

function orbitEnergy {
    parameter orbi is ship:orbit.
    return -orbitGM(orbi) / 2 / orbi:semimajoraxis.
}

function orbitRadius {
    parameter ta is 0.0.
    parameter orbi is ship:orbit.

    local a is orbi:semimajoraxis.
    local e is orbi:eccentricity.

    return a * (1 - e ^ 2) / (1 + e * cos(ta)).
}

function orbitPosAtTA {
    parameter ta is 0.0.
    parameter orbi is ship:orbit.
    local ta0 is orbi:trueanomaly.
    
    local dir is angleAxis(ta - ta0, orbitAngNorm(orbi)) * orbitPos(orbi):normalized.
    local rad is orbitRadius(ta, orbi).

    return rad * dir.
}

function orbitVelAtTA {
    parameter ta is 0.0.
    parameter orbi is ship:orbit.
    local ta0 is orbi:trueanomaly.

    local vel is sqrt(2 *(orbitEnergy(orbi) + orbitGM(orbi) / orbitRadius(ta, orbi))).

    local x is orbitAng(orbi):mag.
    set x to x / vel / orbitRadius(ta, orbi).
    set x to arcsin(min(max(x, 0), 1)).
    if ta - 360 * floor(ta / 360) > 180 {
        set x to 180 - x.
    }
    local dir is angleAxis(ta - ta0 + x, orbitAngNorm(orbi)) * orbitPos(orbi):normalized.

    return vel * dir.
}

function dvCircularize {
    parameter atAP is true.
    parameter orbi is ship:orbit.

    local ta is 0.
    if atAP {
        set ta to 180.
    }

    local r0 is orbitRadius(ta, orbi).
    local gm is orbitGM(orbi).
    local v0 is sqrt(2 *(orbitEnergy(orbi) + gm / r0)).
    local v1 is sqrt(gm / r0).
    return v1 - v0.
}

function dvChangeAPPE {
    parameter h1.
    parameter atAP is true.
    parameter orbi is ship:orbit.

    local ta is 0.
    if atAP {
        set ta to 180.
    }

    set h1 to h1 + orbi:body:radius.
    local r0 is orbitRadius(ta, orbi).
    local gm is orbitGM(orbi).
    local v0 is sqrt(2 *(orbitEnergy(orbi) + gm / r0)).
    local e1 is -gm / (r0 + h1).
    local v1 is sqrt(2 * (e1 + gm / r0)).
    return v1 - v0.
}

function multiStagesBurntime {
    parameter dv is 0.
    parameter stages is list().

    local ret is 0.
    for sta in stages {
        set ret to ret + sta:septime.
        if sta:dv >= dv {
            local endmass is sta:wetmass / (constant:e ^ (dv / (sta:isp * constant:g0))).
            set ret to ret + (sta:wetmass - endmass) / sta:massflow.
            return ret.
        }
        set dv to dv - sta:dv.
        set ret to ret + sta:burntime.
    }
    logPrint("warning: dv insufficient, need more dv: " + dv).
    return ret.
}

fileVersion("0.1.0").
