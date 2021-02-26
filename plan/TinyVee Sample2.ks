@lazyGlobal off.

loadModule("launchOneStage.ks").
loadModule("missionPlan.ks").
logPrint("TinyVee Sample2 mission plans").

local tinyveeSample2 is {
    parameter offset is 2.5.
    parameter range is 90.

    local azimuth is range * (2 * random() - 1) + 90.
    launchOneStage(offset, 60.0, azimuth).
    wait until ship:altitude > 140000.
    wait 1.
    logPrint("separate and deploy parachute").
    stage.
    wait 1.
    stage.
    reportOrbit().
}.

initPlan("TinyVee Sample2").
addPlanConfig("TinyVee 2.5", tinyveeSample2).
addPlanConfig("TinyVee 3.5", tinyveeSample2:bind(3.5)).
addPlanConfig("TinyVee 3.6", tinyveeSample2:bind(2.5, 25)).
