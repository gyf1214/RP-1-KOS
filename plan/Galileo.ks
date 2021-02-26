@lazyGlobal off.

loadModule("launcherRemote.ks").
logPrint("Galileo mission plans").

local galileoPlans is {
    parameter cfg is "main".
    parameter params is lexicon().        
    callLauncher(cfg, params).
}.

initPlan("Galileo").
addPlanConfig("Galileo 2", galileoPlans:bind("polar")).
addPlanConfig("Galileo 3", galileoPlans:bind("main", lexicon("offset", 1.9))).
