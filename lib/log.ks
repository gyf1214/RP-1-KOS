@lazyGlobal off.

if not boot:haskey("logPath") {
    boot:add("logPath", "root:/log/" + core:tag + ".log").
    boot:add("logName", ship:name + " " + time:calendar).
    bool:add("isSimulation", false).
    if not kuniverse:canquicksave {
        set boot:logName to "sim".
        set boot:isSimulation to true.
    }
    logPrint("current log path is " + boot:logPath).
    logPrint("current log name is " + boot:logName).
}

function openOrCreate {
    parameter fpath.
    if not exists(fpath) {
        create(fpath).
    }
    return open(fpath).
}

function logPrint {
    parameter msg is "".
    parameter display is true.

    if display {
        print msg.
    }
    local fullmsg is "[ " + time:calendar + ", " + time:clock + " ] " + msg.
    local fout is openOrCreate(boot:logPath).
    fout:writeln(fullmsg).
}

function reportOrbit {
    local orbi is ship:orbit.
    logPrint("****** Report Orbit ******").
    logPrint("Body:           " + orbi:body:name).
    logPrint("Apoapsis:       " + orbi:apoapsis).
    logPrint("Periapsis:      " + orbi:periapsis).
    logPrint("Inclination:    " + orbi:inclination).
    logPrint("Period:         " + orbi:period).
    logPrint("Eccentricity:   " + orbi:eccentricity).
    logPrint("Argument of PE: " + orbi:argumentofperiapsis).
    logPrint("SemiMajorAxis:  " + orbi:semimajoraxis).
    logPrint("******  End Report  ******").
}

function copyLog {
    logPrint("send log back, waiting for connection").
    wait until homeConnection:isconnected.
    local targetPath to "Archive:/log/" + boot:logName.
    if exists(targetPath) {
        deletePath(targetPath).
    }
    local srcPath is "root:/log".
    copyPath(srcPath, targetPath).
}

fileVersion("0.1.2").
