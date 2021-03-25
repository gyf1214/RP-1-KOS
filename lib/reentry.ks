@lazyGlobal off.

loadModule("nav.ks").
loadModule("vessel.ks").
loadModule("task.ks").

function setRootEC {
    parameter enabled.
    for res in core:part:resources {
        if res:name = "ELECTRICCHARGE" {
            logPrint("set return capsule EC Usage to " + enabled).
            set res:enabled to enabled.
        }
    }
}

function transferScience {
    parameter capsule is core:part.
    if capsule:hasmodule("HardDrive") {
        logPrint("transfer science to " + capsule:name).
        capsule:getModule("HardDrive"):doevent("transfer data here").
    }
}

function reentryTaskControl {
    parameter stayTime is 0.

    local inOrbit is ship:orbit:periapsis > 140000.
    if not inOrbit {
        logPrint("warning: not in orbit, wait until reentry").
        wait until ship:altitude < 140000.
        reentryControl().
    } else {
        set stayTime to eta:apoapsis + ceiling(stayTime / ship:orbit:period) * ship:orbit:period.
        if stayTime > 15 {
            setTask(time:seconds + stayTime, "reentry").
        } else {
            logPrint("waiting for reentry, eta: " + stayTime).
            wait stayTime.
            reentryControl().
        }
    }
}

function reentryControl {
    parameter controlAlt is 100000.
    parameter parachuteAlt is 7000.

    local inOrbit is ship:orbit:periapsis > 140000.
    local reentryInfo is getReentryInfo().
    local capsule is reentryInfo:capsule.
    local serviceRetro is reentryInfo:retro > reentryInfo:separate.

    setRootEC(true).
    transferScience(capsule).

    function separateService {
        logPrint("separate service module").
        wait 1.
        stage.
    }

    if not serviceRetro {
        separateService().
    }
    logPrint("start reentry control").
    rcs on.
    if inOrbit {
        local retroDir is ship:retrograde:forevector.
        lock steering to dirZZ(ship:facing, retroDir).
        wait 1.
        wait until shipStable(retroDir).
        logPrint("ignite reentry engine").
        wait 1.
        stage.
    }
    lock steering to dirZZ(ship:facing, ship:srfretrograde:forevector).
    wait until ship:altitude < controlAlt.
    if serviceRetro {
        separateService().
    }

    if stage:number > reentryInfo:parachute {
        if stage:number > reentryInfo:parachute + 1 {
            logPrint("deploy extra stages").
            until stage:number <= reentryInfo:parachute + 1 {
                wait 1.
                stage.
            }
        }
        when homeConnection:isconnected then {
            copyLog(false).
        }
        wait until ship:altitude < parachuteAlt.
        logPrint("deploy parachute").
        wait 1.
        stage.
    }
    logPrint("end reentry control").
    unlock steering.
}

fileVersion("0.1.0").
