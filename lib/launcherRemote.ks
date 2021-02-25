@lazyGlobal off.

function callLauncher {
    parameter config is "".
    parameter param is lexicon().

    if config:length > 0 {
        param:add("config", config).
    }

    logPrint("wait for launcher ready").
    wait until not core:messages:empty.

    local msg is core:messages:pop():content.
    local remote is msg["who"].
    local hasPS is false.
    logPrint("launcher is " + remote).
    if msg:haskey("postscript") {
        logPrint("postscript found: " + msg["postscript"]).
        set hasPS to true.
        runOncePath(msg["postscript"]).
    }
    processor(remote):connection:sendmessage(param).

    logPrint("wait for launcher finished").
    wait until not core:messages:empty.
    set msg to core:messages:pop():content.
    logPrint("launcer finished").

    if hasPS {
        logPrint("execute postscript").
        launcherPSMain(msg["param"]).
    }
}

logPrint("launcherRemote v0.1.0 loaded").
