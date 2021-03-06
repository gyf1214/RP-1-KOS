@lazyGlobal off.

loadModule("launcherRemote.ks").
logPrint("Newton mission plans").

initPlan("Newton").
addPlanConfig ("Newton 1",  callLauncher@:bind("comm1")).
addPlanConfig ("Newton 2",  callLauncher@:bind("wea1")).
