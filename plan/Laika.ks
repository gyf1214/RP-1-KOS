@lazyGlobal off.

loadModule("launcherRemote.ks").
loadModule("nav.ks").

function setEC {
    parameter enabled.
    for res in core:part:resources {
        if res:name = "ELECTRICCHARGE" {
            logPrint("set return capsule EC Usage to " + enabled).
            set res:enabled to enabled.
        }
    }
}

function transScience {
    parameter capsule is core:part:children[0].
    logPrint("transfer science to " + capsule:name).
    capsule:getModule("HardDrive"):doevent("transfer data here").
}

local laika is {
    parameter params is lexicon().
    parameter maxAlt is 140000.
    parameter controlAlt is 90000.
    setEC(false).
    callLauncher("suborbit", params).
    wait until ship:altitude < maxAlt.
    setEC(true).
    transScience().
    wait 1.
    logPrint("separate science module").
    stage.
    logPrint("start reentry control").
    rcs on.
    lock steering to dirZZ(ship:facing, ship:srfretrograde:forevector).
    wait until ship:altitude < controlAlt.
    logPrint("end reentry control").
    unlock steering.
}.

logPrint("Laika mission plans").
initPlan("Laika").
addPlanConfig ("Laika 1",  laika).
