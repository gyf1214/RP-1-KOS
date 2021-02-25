@lazyGlobal off.

loadModule("launcherRemote.ks").
logPrint("Galileo mission plans").

local galileoPlans is {
    parameter config.
    parameter params is lexicon().        
    callLauncher(config, params).
}.

initPlan("Galileo").
addPlanConfig("Galileo 2", galileoPlans:bind("polar")).
