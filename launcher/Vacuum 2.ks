@lazyGlobal off.

loadModule("orbit.ks").

function vacuum_2 {
    parameter params.
    doLaunchNStages(2, params:offset, 65.0, params:azimuth).
    wait until ship:maxthrust = 0.
}

initLauncher("Vacuum 2", vacuum_2@, lexicon("config", "main", "psname", "Vacuum 1 & 2", "offset", 1.5, "azimuth", 90)).
addLauncherConfig("main").
addLauncherConfig("sso", lexicon("offset", 1.4, "azimuth", 197)).
// addLauncherConfig("comm1", lexicon("offset", 1.1, "azimuth", 123)).
addLauncherConfig("wea1").

logPrint("Vacuum 2 launcher profile v0.1.0 loaded").
