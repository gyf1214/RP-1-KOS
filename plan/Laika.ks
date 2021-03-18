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
    parameter cfg.
    parameter params is lexicon().
    parameter controlAlt is 100000.
    setEC(false).
    callLauncher(cfg, params).
    if cfg = "sample1" {
        wait until ship:altitude < 140000.
    } else {
        local stayTime is 86400.
        set stayTime to eta:apoapsis + ceiling(86400 / ship:orbit:period) * ship:orbit:period.
        logPrint("staying, eta: " + stayTime).
        if addons:available("KAC") {
            addAlarm("Raw", time:seconds + stayTime, ship:name + " Return", "").
        }
        wait stayTime.
    }
    setEC(true).
    transScience().
    wait 1.
    logPrint("separate science module").
    stage.
    logPrint("start reentry control").
    rcs on.
    lock steering to dirZZ(ship:facing, ship:srfretrograde:forevector).
    if cfg <> "sample1" {
        wait 1.
        wait until shipStable(ship:srfretrograde:forevector).
        logPrint("ignite").
        stage.
    }
    wait until ship:altitude < controlAlt.
    logPrint("end reentry control").
    unlock steering.
}.

logPrint("Laika mission plans").
initPlan("Laika").
addPlanConfig ("Laika 1",  laika:bind("sample1")).
addPlanConfig ("Laika 2",  laika:bind("sample2")).
