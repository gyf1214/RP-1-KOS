@lazyGlobal off.

print "Vacuum 1 Orbit Profile".
loadModule("orbitThreeStages.ks").
loadModule("maneuver.ks").

doOrbitThreeStages(2.0, 50.0).
wait until ship:maxthrust = 0.

print "second stage shutdown, lock to maneuver direction".
set ship:control:pilotmainthrottle to 0.0.
lock steering to orbitVelAtTA(180):normalized.
rcs on.

local sepTime is 0.6.
local finalTime is 51.9 + 64.1 + sepTime * 2.

local startTime is eta:apoapsis - finalTime / 2.
wait startTime.
print "deploy third stage".
unlock steering.
rcs off.
stage.
set ship:control:pilotmainthrottle to 1.0.
wait sepTime.
print "ignite engine".
stage.
wait sepTime.

wait until ship:maxthrust = 0.
print "deploy final stage".
stage.
wait sepTime.
print "ignite engine".
stage.
wait sepTime.

wait until ship:maxthrust = 0.
MECO().
print "deploy sat".
stage.
