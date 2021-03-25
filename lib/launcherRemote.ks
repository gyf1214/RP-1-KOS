@lazyGlobal off.

loadModule("launchOneStage.ks").

function callLauncher {
    parameter cfg is "".
    parameter param is lexicon().
    parameter deploy is true.

    if cfg:length > 0 {
        param:add("config", cfg).
    }

    logPrint("wait for launcher ready").
    wait until not core:messages:empty.

    local msg is core:messages:pop():content.
    local remote is msg:who.
    local hasPS is false.
    logPrint("launcher is " + remote).
    if msg:haskey("postscript") {
        logPrint("postscript found: " + msg:postscript).
        set hasPS to true.
        runOncePath(msg:postscript).
    }
    processor(remote):connection:sendmessage(param).

    logPrint("wait for launcher finished").
    wait until not core:messages:empty.
    set msg to core:messages:pop():content.
    logPrint("launcher finished").

    if hasPS {
        logPrint("execute postscript").
        launcherPSMain(msg:param).
    }

    if deploy {
        deployPayload().
    }
}

fileVersion("0.1.1").
