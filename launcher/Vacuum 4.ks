@lazyGlobal off.

loadLauncher("Vacuum").

initLauncher("Vacuum 4", vacuum_launch@:bind(1, 65, 1), lexicon("config", "main", "offset", 1.5, "azimuth", 90)).
addLauncherConfig("main").
addLauncherConfig("comm2", lexicon("offset", 1, "azimuth", 136)).
// deprecated
// addLauncherConfig("tli").

logPrint("Vacuum 4 launcher profile v0.1.0 loaded").
