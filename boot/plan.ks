@lazyGlobal off.

function main {
    copyPath("0:/lib/bootstrap.ks", "bootstrap.ks").
    runOncePath("bootstrap.ks").
    // deletePath("bootstrap.ks").

    local fileName is core:tag + ".ks".

    print "plan system v0.1.1 loaded".
    print "current plan: " + fileName.
    copyPath("0:/plan/" + fileName, fileName).

    print "executing...".
    runPath(fileName).
    print "system shutdown".
}

if ship:status = "PRELAUNCH" {
    main().
}
