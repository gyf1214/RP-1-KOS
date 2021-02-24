@lazyGlobal off.

global launcher is lexicon().

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
    launcher:add("name", name).
    launcher:add("func", func).
    launcher:add("param", param).

    local psSrc is "Archive:/launcher/" + name + ".ps.ks".
    if exists(psSrc) {
        local psDst is "root:/launcher/" + name + ".ps.ks".
        copyPath(psSrc, psDst).
        launcher:add("postscript", psDst).
        logPrint("postscript found, copy to " + psDst).
    }

    launcher:add("config", lexicon()).
}

function addLauncherConfig {
    parameter name.
    parameter param is lexicon().

    logPrint("add launcher config " + name).
    launcher["config"]:add(name, param).
}

function doExecuteLauncher {
    parameter param.
    
    local cfgName is "main".
    if launcher["param"]:haskey("config") {
        set cfgName to launcher["param"]["config"].
    }
    if param:haskey("config") {
        set cfgName to param["config"].
    }
    local configs is launcher["config"].
    local cfg is configs[cfgName].

    logPrint("execute launcher " + launcher["name"] + ", config " + cfgName).
    if cfg:istype("KOSDelegate") {
        combineLexicon(param, launcher["param"]).
        cfg:call(launcher["func"], param).
    } else {
        combineLexicon(param, cfg).
        combineLexicon(param, launcher["param"]).
        launcher["func"]:call(param).
    }
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
    if launcher:haskey("postscript") {
        logPrint("postscript found, send path").
        sent:add("postscript", launcher["postscript"]).
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

logPrint("launcher v0.1.0 loaded").
