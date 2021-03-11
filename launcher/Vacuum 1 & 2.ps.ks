@lazyGlobal off.

loadFile("launcher/Vacuum.ks").

function launcherPSMain {
    parameter params.
    vacuum_circularize(2, params).
}

logPrint("Vacuum 1 & 2 launcher postscript v0.3.0 loaded").
