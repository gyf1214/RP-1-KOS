@lazyGlobal off.

loadModule("launcherRemote.ks").
loadModule("reentry.ks").

local tsiol is {
    parameter cfg.
    parameter params is lexicon().
    
    setRootEC(false).
    callLauncher(cfg, params).
    reentryControl(true, 6 * 86400).
}.

logPrint("Tsiolkovsky: first crewed missions").
initPlan("Tsiolkovsky").
addPlanConfig("Tsiolkovsky 1", tsiol:bind("crew1")).
