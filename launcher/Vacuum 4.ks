@lazyGlobal off.

loadLauncher("Vacuum").

initLauncher("Vacuum 4", vacuum_launch@:bind(1, 65, 1), lexicon("config", "main", "offset", 1.75, "azimuth", 90)).
addLauncherConfig("main").
addLauncherConfig("tli").
addLauncherConfig("comm2", lexicon("offset", 1.1, "azimuth", 145)).
addLauncherConfig("crew1", lexicon("offset", 1.6)).
addLauncherConfig("wea2",  lexicon("offset", 1.1, "azimuth", 200)).
addLauncherConfig("comcons1").
addLauncherConfig("geo1",  lexicon("offset", 1.6, "azimuth", 140)).

fileVersion("0.2.0").
