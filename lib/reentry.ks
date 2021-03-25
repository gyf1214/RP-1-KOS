@lazyGlobal off.

loadModule("nav.ks").

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

function reentryControl {
    parameter serviceRetro.
    parameter stayTime.
    parameter capsule is core:part.
    parameter controlAlt is 100000.
    parameter parachuteAlt is 7000.

    local inOrbit is ship:orbit:periapsis > 140000.
    if not inOrbit {
        wait until ship:altitude < 140000.
    } else {
        set stayTime to eta:apoapsis + ceiling(stayTime / ship:orbit:period) * ship:orbit:period.
        logPrint("staying, eta: " + stayTime).
        if addons:available("KAC") {
            addAlarm("Raw", time:seconds + stayTime, ship:name + " Return", "").
        }
        wait stayTime.
    }

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
    lock steering to dirZZ(ship:facing, ship:srfretrograde:forevector).
    wait 1.
    wait until shipStable(ship:srfretrograde:forevector).
    if inOrbit {
        logPrint("ignite reentry engine").
        wait 1.
        stage.
    }
    wait until ship:altitude < controlAlt.
    if serviceRetro {
        separateService().
    }
    
    if stage:number > 0 {
        logPrint("deploy extra stages").
        until stage:number <= 1 {
            wait 1.
            stage.
        }
        wait until ship:altitude < parachuteAlt.
        logPrint("deploy parachute").
        wait 1.
        stage.
    }
    logPrint("end reentry control").
    unlock steering.
}
