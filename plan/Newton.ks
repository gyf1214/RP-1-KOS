@lazyGlobal off.

loadModule("launcherRemote.ks").
logPrint("Newton mission plans").

initPlan("Newton").
addPlanConfig ("Newton 1",  callLauncher@:bind("comm1")).
addPlanConfig ("Newton 2",  callLauncher@:bind("wea1")).
copyPlanConfig("Newton 3",  "Newton 2").
addPlanConfig ("Newton 4",  callLauncher@:bind("wea1", lexicon("offset", 1.35, "azimuth", 140))).
addPlanConfig ("Newton 5",  callLauncher@:bind("comm2")).
addPlanConfig ("Newton Moon Mission",  callLauncher@:bind("tli")).
