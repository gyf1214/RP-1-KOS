@lazyGlobal off.

loadModule("orbit.ks").
loadModule("vessel.ks").

function launcherPSMain {
    parameter params.

    local stages is getFinalNStagesInfo(2).
    wait until ship:altitude > 140000.
    finalNStages(stages).
}

logPrint("Vacuum 1 postscript v0.2.1 loaded").
