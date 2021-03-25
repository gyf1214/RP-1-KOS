@lazyGlobal off.

parameter prelaunch is true.

function openTerminal {
    // core:doevent("Open Terminal").
    set terminal:height to 72.
    set terminal:width to 54.
    set terminal:brightness to 0.8.
    set terminal:charheight to 10.
}

function loadFile {
    parameter path.
    local oldFile is boot:loadFile.
    local oldCopy is boot:copyFile.
    set boot:loadFile to path.
    if not exists(path) {
        copyPath("Archive:/" + path, path).
        set boot:copyFile to true.
    } else {
        set boot:copyFile to false.
    }
    runOncePath(path).
    set boot:copyFile to oldCopy.
    set boot:loadFile to oldFile.
}

function loadModule {
    parameter path.
    loadFile("lib/" + path).
}

function fileVersion {
    parameter version.
    if boot:copyFile {
        logPrint("Load File: " + boot:loadFile + ", Version: " + version).
    }
}

function bootPlan {
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

global boot is lexicon(
    "loadFile", "lib/bootstrap.ks",
    "copyFile", prelaunch,
    "prelaunch", prelaunch
).

wait until ship:unpacked.
wait 2.
openTerminal().
clearScreen.

global root is ship:rootpart:getmodule("kOSProcessor").
set root:volume:name to "root".

function getRoot {
    return root.
}

loadModule("log.ks").
fileVersion("0.2.3").
