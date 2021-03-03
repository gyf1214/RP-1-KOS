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

    local ret is lexicon(
        "wetmass", wetmass,
        "drymass", drymass,
        "burntime", burnTime,
        "thrust", thrust,
        "isp", isp,
        "massflow", massFlow,
        "dv", dv
    ).
    logPrint("stage " + stagenum + ": " +
             burnTime + "s, " +
             drymass + "t/" + wetmass + "t, " +
             dv + "m/s").
    return ret.
}

function getFinalNStagesInfo {
    parameter N is 0.

    logPrint("find info for final " + N + " stages").
    local ret is list().
    from { local i is 1. } until i > N step { set i to i + 1. } do {
        ret:add(getFinalStageInfo(stage:number - 2 * i)).
    }
    return ret.
}

logPrint("vessel v0.1.1 loaded").
