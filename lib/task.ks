@lazyGlobal off.

loadModule("missionPlan.ks").

function registerTask {
    parameter name.
    logPrint("register task: " + name).
    loadFile("task/" + name + ".ks").
}

function doRegisterTask {
    parameter func.
    parameter param is lexicon().

    if defined task {
        task:add("func", func).
        task:add("param", param).
    }
}

function bootTask {
    local taskCfg is readJson("task.json").

    set boot:logName to taskCfg:logName.
    global task is lexicon().
    loadFile("task/" + taskCfg:name + ".ks").

    if not taskCfg:haskey("param") {
        taskCfg:add("param", lexicon()).
    }
    combineLexicon(taskCfg:param, task:param).
    if time:seconds < taskCfg:time {
        local waitTime is taskCfg:time - time:seconds.
        logPrint("next task: " + taskCfg:name + ", eta: " + waitTime).
        when homeConnection:isconnected then {
            copyLog(false).
        }
        wait waitTime.
    }
    logPrint("execute task: " + taskCfg:name).
    deletePath("task.json").
    task:func:call(taskCfg:param).
}

function setTask {
    parameter clock.
    parameter name.
    parameter param is lexicon().

    logPrint("set task: " + name + ", eta: " + (clock - time:seconds)).
    local taskCfg is lexicon("time", clock, "name", name, "param", param, "logName", boot:logName).
    deletePath("task.json").
    writeJson(taskCfg, "task.json").
    local graceTime is 15.
    if addons:available("KAC") {
        addAlarm("Raw", clock - graceTime, ship:name + ": " + name, "next task for " + ship:name).
    }
}

fileVersion("0.1.0").
