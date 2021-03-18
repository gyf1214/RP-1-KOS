@lazyGlobal off.

loadLauncher("Vacuum").

initLauncher("Vacuum 3", vacuum_launch@:bind(2, 65, 1), lexicon("config", "main", "offset", 1.75, "azimuth", 90)).
addLauncherConfig("main").
addLauncherConfig("comm1", lexicon("offset", 1.2, "azimuth", 120)).
addLauncherConfig("wea1", lexicon("offset", 1.6)).
// deprecated, use Vacuum 4
// addLauncherConfig("comm2", lexicon("offset", 1.1, "azimuth", 136)).
addLauncherConfig("sample1").
addLauncherConfig("sample2").

logPrint("Vacuum 3 launcher profile v0.2.2 loaded").
