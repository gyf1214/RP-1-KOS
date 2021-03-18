@lazyGlobal off.

loadModule("launcherRemote.ks").
logPrint("Lagrange: General Purpose Satellite Platform with control").

initPlan("Lagrange").
addPlanConfig ("Lagrange 1",  callLauncher@:bind("tli")).
