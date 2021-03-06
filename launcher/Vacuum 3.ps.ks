@lazyGlobal off.

loadModule("orbit.ks").
loadModule("vessel.ks").

function launcherPSMain {
    parameter params.

    local stages is getFinalNStagesInfo(1).
    
    wait until ship:altitude > 140000.
    if params:config = "comm1" {
        targetOrbitAPPE(stages, 4500000, 800000).
    } else {
        finalNStages(stages).
    }
}

logPrint("Vacuum 3 postscript v0.1.0 loaded").
