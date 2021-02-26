@lazyGlobal off.

loadModule("orbit.ks").

function vacuum_1 {
    parameter params.
    doLaunchNStages(2, params["offset"], 50.0, params["azimuth"]).
    wait until ship:maxthrust = 0.
}

initLauncher("Vacuum 1", vacuum_1@, lexicon("config", "main", "offset", 2, "azimuth", 90, "finalStages", list(64.5, 51.9))).
addLauncherConfig("main").
addLauncherConfig("polar", lexicon("offset", 2, "azimuth", 190)).
addLauncherConfig("sso", lexicon("offset", 1.7, "azimuth", 197, "finalStages", list(64.5, 67.3))).

logPrint("Vacuum 1 launcher profile v0.1.0 loaded").
