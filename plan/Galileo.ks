@lazyGlobal off.

loadModule("launcherRemote.ks").

initPlan("Galileo").
logPrint("Galileo: First Satellite").
addPlanConfig ("Galileo 1",  callLauncher@:bind("main")).
addPlanConfig ("Galileo 2",  callLauncher@:bind("polar")).
addPlanConfig ("Galileo 3",  callLauncher@:bind("main", lexicon("offset", 1.9))).
addPlanConfig ("Galileo 4",  callLauncher@:bind("main", lexicon("offset", 1.8))).
addPlanConfig ("Galileo 5",  callLauncher@:bind("nav")).
copyPlanConfig("Galileo 6",  "Galileo 4").
copyPlanConfig("Galileo 7",  "Galileo 5").
addPlanConfig ("Galileo 8",  callLauncher@:bind("sso")).
copyPlanConfig("Galileo 9",  "Galileo 8").
// deprecated, switch to Newton 1
// addPlanConfig ("Galileo 10", callLauncher@:bind("comm1")).
