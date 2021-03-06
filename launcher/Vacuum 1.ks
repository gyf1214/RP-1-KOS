@lazyGlobal off.

loadModule("orbit.ks").

function vacuum_1 {
    parameter params.
    doLaunchNStages(2, params:offset, 50.0, params:azimuth).
    wait until ship:maxthrust = 0.
}

initLauncher("Vacuum 1", vacuum_1@, lexicon("config", "main", "offset", 2, "azimuth", 90)).
addLauncherConfig("main").
addLauncherConfig("polar", lexicon("offset", 2, "azimuth", 190)).
// addLauncherConfig("sso", lexicon("offset", 1.85, "azimuth", 197)).
addLauncherConfig("nav", lexicon("offset", 1.7, "azimuth", 135)).

logPrint("Vacuum 1 launcher profile v0.2.0 loaded").
