@lazyGlobal off.

function orbitPos {
    parameter orbi is ship:orbit.
    return orbi:position - orbi:body:position.
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

    local dir is angleAxis(ta - ta0 + 90, orbitAngNorm(orbi)) * orbitPos(orbi):normalized.
    local vel is sqrt(2 *(orbitEnergy(orbi) + orbitGM(orbi) / orbitRadius(ta, orbi))).

    return vel * dir.
}

print "maneuver v0.1.0 loaded".
