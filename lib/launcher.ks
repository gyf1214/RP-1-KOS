@lazyGlobal off.

loadModule("missionPlan.ks").

// a = a + b, non-overwrite, deep
function combineLexicon {
    parameter a.
    parameter b.

    for k in b:keys {
        if not a:haskey(k) {
            a:add(k, b[k]).
        }
    }
}

function initLauncher {
    parameter name.
    parameter func.
    parameter param is lexicon().
    
    logPrint("init launcher " + name).
    initPlan(name).
    plan:add("func", func).
    plan:add("param", param).

    local psSrc is "Archive:/launcher/" + name + ".ps.ks".
    if exists(psSrc) {
        local psDst is "root:/launcher/" + name + ".ps.ks".
        copyPath(psSrc, psDst).
        plan:add("postscript", psDst).
        logPrint("postscript found, copy to " + psDst).
    }
}

function addLauncherConfig {
    parameter name.
    parameter param is lexicon().

    logPrint("add launcher config " + name).
    if param:istype("KOSDelegate") {
        addPlanConfig(name, {
            parameter param1 is lexicon().
            combineLexicon(param1, plan:param).
            param:call(plan:func, param).
        }).
    } else {
        addPlanConfig(name, {
            parameter param1 is lexicon().
            combineLexicon(param1, param).
            combineLexicon(param1, plan:param).
            plan:func:call(param1).
        }).
    }
}

function doExecuteLauncher {
    parameter param is lexicon().
    
    local cfgName is "main".
    if plan:param:haskey("config") {
        set cfgName to plan:param:config.
    }
    if param:haskey("config") {
        set cfgName to param:config.
    }
    logPrint("execute launcher " + plan:name + ", config " + cfgName).
    doExecutePlan(cfgName, param).
}

function loadLauncher {
    parameter name.

    local path is "launcher/" + name + ".ks".
    logPrint("load launcher from path " + path).
    loadFile(path).
}

function executeLauncher {
    logPrint("send startLauncher").
    local sent is lexicon("what", "startLauncher", "who", core:tag).
    if plan:haskey("postscript") {
        logPrint("postscript found, send path").
        sent:add("postscript", plan:postscript).
    }
    root:connection:sendmessage(sent).
    
    logPrint("wait for root").
    wait until not core:messages:empty.
    logPrint("recv param from root").
    local param is core:messages:pop():content.
    doExecuteLauncher(param).
    logPrint("finish execute launcher").

    logPrint("send finishLauncher").
    local ret is lexicon("what", "finishLauncher", "param", param).
    root:connection:sendmessage(ret).
}

function executeLauncherLocal {
    parameter name.
    parameter cfg is "".
    parameter param is lexicon().

    if cfg:length > 0 {
        param:add(cfg).
    }

    loadLauncher(name).
    if plan:haskey("postscript") {
        logPrint("load postscript").
        runOncePath(plan:postscript).
    }
    logPrint("start execute launcher").
    doExecuteLauncher(param).
    logPrint("finish execute launcher").
    if plan:haskey("postscript") {
        logPrint("execute postscript").
        launcherPSMain(param).
    }
}

logPrint("launcher v0.1.1 loaded").
