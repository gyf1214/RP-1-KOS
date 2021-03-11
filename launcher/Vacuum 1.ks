@lazyGlobal off.

loadLauncher("Vacuum").

initLauncher("Vacuum 1", vacuum_launch@:bind(2, 50, 0), lexicon("config", "main", "psname", "Vacuum 1 & 2", "offset", 2, "azimuth", 90)).
addLauncherConfig("main").
addLauncherConfig("polar", lexicon("offset", 2, "azimuth", 190)).
addLauncherConfig("nav", lexicon("offset", 1.7, "azimuth", 135)).

logPrint("Vacuum 1 launcher profile v0.2.1 loaded").
