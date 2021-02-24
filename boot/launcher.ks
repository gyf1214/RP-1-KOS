@lazyGlobal off.

function main {
    local path is "lib/bootstrap.ks".
    copyPath("Archive:/" + path, path).
    runOncePath(path).
    
    bootLauncher().
}

if ship:status = "PRELAUNCH" {
    main().
}
