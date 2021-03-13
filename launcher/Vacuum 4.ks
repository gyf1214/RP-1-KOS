@lazyGlobal off.

loadLauncher("Vacuum").

initLauncher("Vacuum 4", vacuum_launch@:bind(1, 65, 1), lexicon("config", "main", "offset", 1.7, "azimuth", 90)).
addLauncherConfig("main").
addLauncherConfig("tli").
addLauncherConfig("comm2", lexicon("offset", 1.1, "azimuth", 142)).

logPrint("Vacuum 4 launcher profile v0.2.0 loaded").
