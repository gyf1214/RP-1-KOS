@lazyGlobal off.

loadModule("orbit.ks").
loadModule("vessel.ks").

function vacuum_circularize {
    parameter stageNum.
    parameter params.

    local stages is getFinalNStagesInfo(stageNum).

    wait until ship:altitude > 140000.
    if params:config = "sso" {
        targetOrbitEcc(stages, 0.03, 300000).
    } else if params:config = "comm1" {
        targetOrbitAPPE(stages, 4500000, 800000).
    } else if params:config = "wea1" {
        targetOrbitEcc(stages, 0.004, 300000).
    } else {
        finalNStages(stages).
    }
}

logPrint("Vacuum Circularize launcher profile v0.2.0 loaded").
