@lazyGlobal off.

loadModule("launcherRemote.ks").
loadModule("reentry.ks").

local tsiol is {
    parameter cfg.
    parameter params is lexicon().
    
    setRootEC(false).
    callLauncher(cfg, params).
    reentryTaskControl(6 * 86400).
}.

initPlan("Tsiolkovsky").
logPrint("Tsiolkovsky: first crewed missions").
addPlanConfig("Tsiolkovsky 1", tsiol:bind("crew1")).
