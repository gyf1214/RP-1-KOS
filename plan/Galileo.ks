@lazyGlobal off.

loadModule("launcherRemote.ks").
logPrint("Galileo mission plans").

local galileoPlans is {
    parameter cfg is "main".
    parameter params is lexicon().        
    callLauncher(cfg, params).
}.

initPlan("Galileo").
addPlanConfig ("Galileo 1",  galileoPlans:bind("main")).
addPlanConfig ("Galileo 2",  galileoPlans:bind("polar")).
addPlanConfig ("Galileo 3",  galileoPlans:bind("main", lexicon("offset", 1.9))).
addPlanConfig ("Galileo 4",  galileoPlans:bind("main", lexicon("offset", 1.8))).
addPlanConfig ("Galileo 5",  galileoPlans:bind("nav")).
copyPlanConfig("Galileo 6",  "Galileo 4").
copyPlanConfig("Galileo 7",  "Galileo 5").
addPlanConfig ("Galileo 8",  galileoPlans:bind("sso")).
copyPlanConfig("Galileo 9",  "Galileo 8").
addPlanConfig ("Galileo 10", galileoPlans:bind("comm1")).
