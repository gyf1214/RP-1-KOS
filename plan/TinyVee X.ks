@lazyGlobal off.

loadModule("launchOneStage.ks").
loadModule("missionPlan.ks").
logPrint("TinyVee X mission plans").

local tinyveeX is {
    parameter offset is 2.5.
    parameter range is 90.
    parameter maxAlt is 140000.

    local azimuth is range * (2 * random() - 1) + 90.
    launchOneStage(offset, 60.0, azimuth).
    wait until ship:altitude > maxAlt.
    wait 1.
    logPrint("separate and deploy parachute").
    stage.
    wait 1.
    stage.
    reportOrbit().
    wait until ship:altitude < maxAlt.
    logPrint("deploy air brake").
    brakes on.
}.

initPlan("TinyVee X").
addPlanConfig("TinyVee X-2", tinyveeX:bind(2.5, 90)).
addPlanConfig("TinyVee X-3", tinyveeX:bind(1, 0)).
addPlanConfig("TinyVee X-4", tinyveeX:bind(2.5, 0)).
