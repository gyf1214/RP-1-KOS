@lazyGlobal off.

loadModule("launcherRemote.ks").

initPlan("Lagrange").
logPrint("Lagrange: General Purpose Satellite Platform with control").
addPlanConfig ("Lagrange 1",  callLauncher@:bind("tli")).
