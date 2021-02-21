@lazyGlobal off.

print "TinyVB Random General Profile".
loadModule("launchOneStage.ks").

local azimuth is 360 * random().
launchOneStage(2, 60.0, azimuth).
set ship:control:mainthrottle to 1.0.
stage.
wait 1.
stage.
