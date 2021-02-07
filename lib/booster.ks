@lazyGlobal off.

function addBoosterTag {
    parameter tag is "booster".
    parameter afterStage is stage:number - 2.
    parameter waitTime is 1.5.

    local booster is ship:partsTagged(tag)[0].

    when booster:maxThrust = 0 and stage:number <= afterStage then {
        print "booster " + tag + " flame out".
        wait waitTime.
        print "decouple booster".
        stage.
    }
}

function addBoosterTimeout {
    parameter boostTime.
    parameter launchWaitTime is 4.
    
    local deployTime is time:seconds + boostTime + launchWaitTime.
    when time:seconds > deployTime then {
        print "decouple booster".
        stage.
    }
}

print "booster v0.1.0 loaded".
