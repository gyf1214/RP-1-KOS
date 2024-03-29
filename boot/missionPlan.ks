@lazyGlobal off.

function main {
    parameter prelaunch is true.

    local path is "lib/bootstrap.ks".
    if prelaunch {
        copyPath("Archive:/" + path, path).
    }
    runOncePath(path, prelaunch).
    
    bootMissionPlan().
}

main(ship:status = "PRELAUNCH").
