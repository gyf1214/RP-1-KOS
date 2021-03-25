@lazyGlobal off.

parameter prelaunch is true.

function openTerminal {
    // core:doevent("Open Terminal").
    set terminal:height to 72.
    set terminal:width to 54.
    set terminal:brightness to 0.8.
    set terminal:charheight to 10.
}

function copyFile {
    parameter path.
    copyPath("Archive:/" + path, path).
}

function loadFile {
    parameter path.
    local oldFile is boot:loadFile.
    local oldCopy is boot:copyFile.
    set boot:loadFile to path.
    if not exists(path) {
        copyFile(path).
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
    parameter versionStr.
    if boot:copyFile {
        logPrint("Load File: " + boot:loadFile + ", Version: " + versionStr).
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

function taskReboot {
    if exists("task.json") {
        logPrint("system reboot for task").
        copyLog(false).
        reboot.
    } else {
        logPrint("system shutdown").
        copyLog(true).
        shutdown.
    }
}

function bootMissionPlan {
    if prelaunch {
        loadModule("missionPlan.ks").
        loadFile("plan/" + core:tag + ".ks").
        doExecutePlan(ship:name).
        taskReboot().   
    } else if exists("task.json") {
        loadModule("task.ks").
        bootTask().
        taskReboot().
    } else {
        logPrint("user power on, proceeding...").
        copyLog(false).
        core:doevent("Open Terminal").
    }
}

// a = a + b, non-overwrite, shallow
function combineLexicon {
    parameter a.
    parameter b.

    for k in b:keys {
        if not a:haskey(k) {
            a:add(k, b[k]).
        }
    }
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
