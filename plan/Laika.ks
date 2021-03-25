@lazyGlobal off.

loadModule("launcherRemote.ks").
loadModule("reentry.ks").

local laika is {
    parameter cfg.
    parameter params is lexicon().
    setRootEC(false).
    callLauncher(cfg, params).

    local capsule is core:part:children[0].
    reentryControlc(false, 86400, capsule).
}.

logPrint("Laika: sample return missions").
initPlan("Laika").
addPlanConfig ("Laika 1",  laika:bind("sample1")).
addPlanConfig ("Laika 2",  laika:bind("sample2")).
copyPlanConfig("Laika 3", "Laika 2").
