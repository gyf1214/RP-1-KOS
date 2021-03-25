@lazyGlobal off.

function openTerminal {
    // core:doevent("Open Terminal").
    set terminal:height to 72.
    set terminal:width to 54.
    set terminal:brightness to 0.8.
    set terminal:charheight to 10.
}

openTerminal().

function loadFile {
    parameter path.
    if not exists(path) {
        copyPath("Archive:/" + path, path).
    }
    runOncePath(path).
}

function loadModule {
    parameter path.
    loadFile("lib/" + path).
}

function bootPlan {
    logPrint("plan system v0.1.2 loaded").
    logPrint("current plan: " + core:tag).
    logPrint("executing...").
    
    loadFile("plan/" + core:tag + ".ks").
    
    logPrint("system shutdown").
    copyLog().
    shutdown.
}

function bootLauncher {
    loadModule("launcher.ks").
    loadLauncher(core:tag).

    executeLauncher().

    logPrint("system shutdown").
    shutdown.
}

function bootMissionPlan {
    loadModule("missionPlan.ks").
    loadFile("plan/" + core:tag + ".ks").
    doExecutePlan(ship:name).
    
    logPrint("system shutdown").
    copyLog().
    shutdown.
}

wait until ship:unpacked.
wait 2.
clearScreen.

global root is ship:rootpart:getmodule("kOSProcessor").
set root:volume:name to "root".

function getRoot {
    return root.
}

loadModule("log.ks").
logPrint("bootstrap v0.2.3 loaded").
