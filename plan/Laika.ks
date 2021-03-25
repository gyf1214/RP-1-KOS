@lazyGlobal off.

loadModule("launcherRemote.ks").
loadModule("reentry.ks").

local laika is {
    parameter cfg.
    parameter params is lexicon().
    setRootEC(false).
    callLauncher(cfg, params).

    reentryTaskControl(86400).
}.

initPlan("Laika").
logPrint("Laika: sample return missions").
addPlanConfig ("Laika 1",  laika:bind("sample1")).
addPlanConfig ("Laika 2",  laika:bind("sample2")).
copyPlanConfig("Laika 3", "Laika 2").
