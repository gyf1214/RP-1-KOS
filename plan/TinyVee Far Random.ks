@lazyGlobal off.

print "TinyVee Random General Profile".
loadModule("launchOneStage.ks").

local azimuth is 360 * random().
launchOneStage(2, 60.0, azimuth).
