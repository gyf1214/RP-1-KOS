@lazyGlobal off.

function getTrueStage {
    parameter part.
    
    if part:istype("engine") {
        return part:decoupledin.
    }
    if part:istype("decoupler") {
        return part:stage.
    }
    if part:hasparent and part:stage = 0 {
        return getTrueStage(part:parent).
    }
    return part:decoupledin.
}

function getFinalStageInfo {
    parameter stagenum is 0.

    local wetmass is 0.
    local drymass is 0.
    local isp is 0.
    local thrust is 0.
    local hasMotor is false.

    logPrint("find info for stage: " + stagenum).
    for part in ship:parts {
        local truestage is getTrueStage(part).
        if truestage < stagenum {
            if part:istype("engine") and part:stage = stagenum {
                set thrust to thrust + part:possiblethrustat(0).
                set isp to part:visp.
                set wetmass to wetmass + part:wetmass.
                set drymass to drymass + part:drymass.
                logPrint("engine: " + part:name).
            } else if part:istype("engine") and part:stage > stagenum {
                set wetmass to wetmass + part:drymass.
                set drymass to drymass + part:drymass.
                set hasMotor to true.
                logPrint("spin motor: " + part:name).
            } else if truestage = stagenum - 1 {
                set wetmass to wetmass + part:wetmass.
                set drymass to drymass + part:drymass.
                logPrint("stage mass: " + part:name).
            } else {
                set wetmass to wetmass + part:wetmass.
                set drymass to drymass + part:wetmass.
                logPrint("dead mass: " + part:name).
            }
        }
    }

    local massFlow is thrust / (constant:g0 * isp).
    local burnTime is (wetmass - drymass) / massFlow.
    local dv is ln(wetmass / drymass) * constant:g0 * isp.
    local sepTime is 0.7.
    if not hasMotor {
        set sepTime to 5.
    }

    local ret is lexicon(
        "wetmass", wetmass,
        "drymass", drymass,
        "burntime", burnTime,
        "thrust", thrust,
        "isp", isp,
        "massflow", massFlow,
        "dv", dv,
        "hasmotor", hasMotor,
        "septime", sepTime
    ).
    logPrint("stage " + stagenum + ": " + burnTime + "s").
    logPrint("mass: " + drymass + "t/" + wetmass + "t").
    logPrint("dv: " + dv + "m/s").
    logPrint("has sep motor: " + hasMotor).
    logPrint("separation time: " + sepTime).
    return ret.
}

function getFinalNStagesInfo {
    parameter N is 0.
    parameter stagenum is stage:number - 2.

    logPrint("find info for final " + N + " stages").
    local ret is list().
    from { local i is 0. } until i >= N step { set i to i + 1. } do {
        ret:add(getFinalStageInfo(stagenum - 2 * i)).
    }
    return ret.
}

function getAllFairings {
    local a is list().
    local b is list().
    local maxStage is 1.

    for part in ship:parts {
        if part:hasModule("ProceduralFairingDecoupler") {
            a:add(part).
            if part:stage > maxStage {
                set maxStage to part:stage.
            }
        }
    }

    for part in a {
        if part:stage = maxStage {
            b:add(part).
        }
    }
    return b.
}

function getPartDecoupler {
    parameter part.

    until part:istype("decoupler") or not part:hasparent {
        set part to part:parent.
    }

    if not part:istype("decoupler") {
        logPrint("warning: cannot get decoupler for part: " + part:name).
    }
    return part.
}

function getCoreStageInfo {
    parameter stageNum.
    
    local a is list().
    local minStage is stage:number.
    local ret is lexicon("coreEngines", list(), "boosters", list()).

    logPrint("find boosters in lift stage " + stageNum).
    for engine in ship:parts {
        if engine:istype("engine") and engine:stage >= stageNum {
            a:add(engine).
            if engine:decoupledin < minStage {
                set minStage to engine:decoupledin.
            }
        }
    }

    logPrint("core engine decoupled in stage " + minStage).
    ret:add("coreStage", minStage).
    for engine in a {
        if engine:decoupledin = minStage {
            logPrint("core engine: " + engine:name).
            ret:coreEngines:add(engine).
        } else {
            logPrint("booster: " + engine:name).
            local decoupler is getPartDecoupler(engine).
            ret:boosters:add(lexicon("engine", engine, "decoupler", decoupler, "stage", engine:decoupledin)).
        }
    }

    return ret.
}

logPrint("vessel v0.1.4 loaded").
