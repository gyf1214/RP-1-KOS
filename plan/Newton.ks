@lazyGlobal off.

loadModule("launcherRemote.ks").

initPlan("Newton").
logPrint("Newton: First Gen General Purpose Satellite Platform").
addPlanConfig ("Newton 1",  callLauncher@:bind("comm1")).
addPlanConfig ("Newton 2",  callLauncher@:bind("wea1")).
copyPlanConfig("Newton 3",  "Newton 2").
addPlanConfig ("Newton 4",  callLauncher@:bind("wea1", lexicon("offset", 1.35, "azimuth", 140))).
addPlanConfig ("Newton 5",  callLauncher@:bind("tli")).
copyPlanConfig("Newton 6",  "Newton 4").
addPlanConfig ("Newton 7",  callLauncher@:bind("comm2")).
copyPlanConfig("Newton 8",  "Newton 4").
copyPlanConfig("Newton 9",  "Newton 5").
copyPlanConfig("Newton 10", "Newton 4").
copyPlanConfig("Newton 11", "Newton 4").
copyPlanConfig("Newton 12", "Newton 5").
copyPlanConfig("Newton 13", "Newton 7").
addPlanConfig ("Newton 14", callLauncher@:bind("nav2")).
copyPlanConfig("Newton 15", "Newton 5").
copyPlanConfig("Newton 16", "Newton 14").
copyPlanConfig("Newton 17", "Newton 4").
copyPlanConfig("Newton 18", "Newton 14").
copyPlanConfig("Newton 19", "Newton 4").
copyPlanConfig("Newton 20", "Newton 14").
copyPlanConfig("Newton 21", "Newton 7").
copyPlanConfig("Newton 22", "Newton 14").
addPlanConfig ("Newton 23", callLauncher@:bind("scan1")).
