@lazyGlobal off.

function openTerminal {
    core:doevent("Open Terminal").
    set terminal:height to 48.
    set terminal:width to 42.
    set terminal:brightness to 0.8.
    set terminal:charheight to 14.
}

function loadFile {
    parameter path.
    copyPath("Archive:/" + path, path).
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

wait until ship:unpacked.
clearScreen.

global root is ship:rootpart:getmodule("kOSProcessor").
set root:volume:name to "root".

function getRoot {
    return root.
}

loadModule("log.ks").
logPrint("bootstrap v0.2.1 loaded").
