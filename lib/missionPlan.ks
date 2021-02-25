@lazyGlobal off.

global plan is lexicon().

function initPlan {
    parameter name.
    plan:add("name", name).
    plan:add("config", lexicon()).
    logPrint("init plan " + name).
}

function addPlanConfig {
    parameter name.
    parameter func.
    plan["config"]:add(name, func).
    logPrint("add plan config " + name).
}

function copyPlanConfig {
    parameter name.
    parameter name1.
    plan["config"]:add(name, plan["config"][name1]).
}

function doExecutePlan {
    parameter cfg.
    parameter param is "".

    logPrint("start execute plan config " + cfg).
    local f is plan["config"][cfg].
    if param:istype("lexicon") {
        set f to f:bind(param).
    }
    f:call().
    logPrint("finish execute plan config " + cfg).
}

logPrint("missionPlan v0.1.0 loaded").
