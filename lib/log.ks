global logPath is "root:/log/" + core:tag + ".log".
if not kuniverse:canquicksave {
    set logPath to "Archive:/log/sim/" + core:tag + ".log".
    deletePath("Archive:/log/sim").
}
global logName is ship:name + " " + time:calendar.

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
    local fout is openOrCreate(logPath).
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
    if kuniverse:canquicksave {
        // this is actual launch
        local targetPath to "Archive:/log/" + logName.
        if exists(targetPath) {
            deletePath(targetPath).
        }
        local srcPath is "root:/log".
        if not exists(srcPath) {
            set srcPath to "Archive:/log/sim".
        }
        copyPath(srcPath, targetPath).
    }
}

logPrint("log v0.1.0 loaded").
logPrint("current log path is " + logPath).
