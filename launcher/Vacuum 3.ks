@lazyGlobal off.

loadModule("orbit.ks").

function vacuum_3 {
    parameter params.
    doLaunchNStages(2, params:offset, 65.0, params:azimuth).
    wait until ship:maxthrust = 0.
}

initLauncher("Vacuum 3", vacuum_3@, lexicon("config", "main", "offset", 2, "azimuth", 90)).
addLauncherConfig("main").
addLauncherConfig("comm1", lexicon("offset", 1.25, "azimuth", 120)).

logPrint("Vacuum 3 launcher profile v0.1.0 loaded").
