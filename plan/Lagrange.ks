@lazyGlobal off.

loadModule("launcherRemote.ks").

initPlan("Lagrange").
logPrint("Lagrange: General Purpose Satellite Platform with control").
addPlanConfig ("Lagrange 1",  callLauncher@:bind("tli")).
addPlanConfig ("Lagrange 2",  callLauncher@:bind("wea2")).
addPlanConfig ("Lagrange 3",  callLauncher@:bind("comcons1")).
copyPlanConfig("Lagrange 4", "Lagrange 2").
copyPlanConfig("Lagrange 5", "Lagrange 1").
copyPlanConfig("Lagrange 6", "Lagrange 4").
addPlanConfig ("Lagrange 7",  callLauncher@:bind("geo1")).
