@lazyGlobal off.

global mj is core:part:getModule("MechJebCore").

function mjKillRot {
    unlock steering.
    mj:doAction("orbit kill rotation", true).
}

function mjRelease {
    mj:doAction("deactivate smartacs", true).
}