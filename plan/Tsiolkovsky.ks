@lazyGlobal off.

loadModule("launcherRemote.ks").
loadModule("reentry.ks").

local tsiol is {
    parameter cfg.
    parameter stayTime.
    parameter params is lexicon().
    
    setRootEC(false).
    callLauncher(cfg, params).
    reentryTaskControl(stayTime).
}.

initPlan("Tsiolkovsky").
logPrint("Tsiolkovsky: first crewed missions").
addPlanConfig("Tsiolkovsky 1", tsiol:bind("crew1", 6 * 86400)).
addPlanConfig("Tsiolkovsky 2", tsiol:bind("crew1", 3 * 86400)).
addPlanConfig("Tsiolkovsky 3", tsiol:bind("crew1", 1 * 86400)).
