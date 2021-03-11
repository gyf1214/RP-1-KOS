@lazyGlobal off.

loadLauncher("Vacuum").

initLauncher("Vacuum 2", vacuum_launch@:bind(2, 65, 0), lexicon("config", "main", "psname", "Vacuum 1 & 2", "offset", 1.5, "azimuth", 90)).
addLauncherConfig("main").
addLauncherConfig("sso", lexicon("offset", 1.4, "azimuth", 197)).
// deprecated, use Vacuum 3
// addLauncherConfig("comm1", lexicon("offset", 1.1, "azimuth", 123)).
// addLauncherConfig("wea1").

logPrint("Vacuum 2 launcher profile v0.1.1 loaded").
