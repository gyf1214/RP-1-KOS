@lazyGlobal off.

loadModule("orbit.ks").
loadLauncher("Vacuum Circularize").

function vacuum_3 {
    parameter params.
    doLaunchNStages(2, params:offset, 65.0, params:azimuth).
    wait until ship:maxthrust = 0.
    vacuum_circularize(1, params).
}

initLauncher("Vacuum 3", vacuum_3@, lexicon("config", "main", "offset", 1.75, "azimuth", 90)).
addLauncherConfig("main").
addLauncherConfig("comm1", lexicon("offset", 1.2, "azimuth", 120)).
addLauncherConfig("wea1", lexicon("offset", 1.6)).

logPrint("Vacuum 3 launcher profile v0.2.0 loaded").
