@lazyGlobal off.

loadModule("orbit.ks").
loadModule("vessel.ks").

function launcherPSMain {
    parameter params.

    local stages is getFinalNStagesInfo(2).

    wait until ship:altitude > 140000.
    if params:config = "sso" {
        targetOrbitEcc(stages, 0.03, 300000).
    } else if params:config = "comm1" {
        targetOrbitAPPE(stages, 4500000, 800000).
    } else {
        finalNStages(stages).
    }
}

logPrint("Vacuum 2 postscript v0.2.0 loaded").
