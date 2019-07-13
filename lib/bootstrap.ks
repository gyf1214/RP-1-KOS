@lazyGlobal off.

function openTerminal {
    core:doevent("Open Terminal").
    set terminal:height to 48.
    set terminal:width to 42.
    set terminal:brightness to 0.8.
    set terminal:charheight to 14.
}

function loadModule {
    parameter path.

    copyPath("0:/lib/" + path, path).
    runOncePath(path).
    // deletePath(path).
}

wait 5.
openTerminal().

clearScreen.
print "bootstrap v0.1.2 loaded".
