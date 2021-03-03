@lazyGlobal off.

function logPrint {
    parameter msg is "".
    print msg.
}

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
    parameter stage is 0.

    local wetmass is 0.
    local drymass is 0.
    local isp is 0.
    local thrust is 0.

    for part in ship:parts {
        local truestage is getTrueStage(part).
        if truestage < stage {
            if part:istype("engine") and part:stage = stage {
                set thrust to thrust + part:possiblethrustat(0).
                set isp to part:visp.
                set wetmass to wetmass + part:wetmass.
                set drymass to drymass + part:drymass.
                logPrint("engine: " + part:name).
            } else if part:istype("engine") and part:stage > stage {
                set wetmass to wetmass + part:drymass.
                set drymass to drymass + part:drymass.
                logPrint("spin motor: " + part:name).
            } else if truestage = stage - 1 {
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

    logPrint("wet mass: " + wetmass).
    logPrint("dry mass: " + drymass).
    logPrint("burntime: " + burnTime).
    logPrint("dv: " + dv).
}
