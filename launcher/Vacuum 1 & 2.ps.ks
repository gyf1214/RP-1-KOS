@lazyGlobal off.

loadFile("launcher/Vacuum.ks").

function launcherPSMain {
    parameter params.
    vacuum_circularize(2, params).
}

fileVersion("0.3.0").
