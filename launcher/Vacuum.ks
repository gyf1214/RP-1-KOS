@lazyGlobal off.

loadModule("orbit.ks").
loadModule("vessel.ks").

function vacuum_circularize {
    parameter stageNum.
    parameter params.

    local stages is getFinalNStagesInfo(stageNum).

    wait until ship:altitude > 100000.
    if params:config = "sso" {
        targetOrbitEcc(stages, 0.03, 300000).
    } else if params:config = "comm1" {
        targetOrbitAPPE(stages, 4500000, 800000).
    } else if params:config = "comm2" {
        targetOrbitAPPE(stages, 5000000, 1000000).
    } else if params:config = "wea1" {
        targetOrbitEcc(stages, 0.004, 300000).
    } else if params:config = "tli" {
        targetOrbitAlt(stages, 350000000).
    } else {
        finalNStages(stages).
    }
}

function vacuum_launch {
    parameter stageNum.
    parameter finalStageNum.
    parameter turnStart.
    parameter params.

    doLaunchNStages(stageNum, params:offset, turnStart, params:azimuth).
    wait until ship:maxthrust = 0.
    if finalStageNum > 0 {
        vacuum_circularize(finalStageNum, params).
    }
}

logPrint("Vacuum launcher profile v0.3.1 loaded").
