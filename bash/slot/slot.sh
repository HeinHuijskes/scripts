#!/bin/bash

cd "$HOME/scripts/bash/slot/"

debugger="../debug.sh"
$debugger -c

function log() {
    $debugger ${@};
    $debugger "";
}

# INITIALIZE VALUES #
coins=10    # [Number] Number of coins
speed=2     # [Number] Speed factor, must be a whole number of 0 or higher
crank=0.1   # [Number] Handle animation speed

while getopts "hs:c:d" opt ; do
    case $opt in 
        h) # Display help
            # TODO: Expand help text to show different options
            echo 'Watch out for gambling addiction';
            exit
            ;;
        s) # Set speed
            setspeed="$OPTARG"
            case $setspeed in
                instant)
                    speed=0
                    crank=0
                    echo 'Set speed to instant';;
                slow)
                    speed=3
                    crank=0.2
                    echo 'Set speed to slow';;
                medium)
                    speed=2
                    crank=0.1
                    echo 'Set speed to medium';;
                fast)
                    speed=1
                    crank=0.05
                    echo 'Set speed to fast';;
                *)
                    speed=2
                    crank=0.1
                    echo 'Unknown, set speed to standard';
            esac
            ;;
        c)
            coins=$OPTARG
            if [ $(($coins-$coins)) != 0 ] || [ $coins -gt 999 ] 2>/dev/null; then
                coins=10;
            fi
            ;;
    esac
    sleep 1
done

# IMPORT UI FUNCTIONS FROM ./slotui.sh #
source "./slotui.sh"


initialize () {
    # Show the cursor on script exit
    trap "tput cnorm" EXIT
    # Hide the cursor
    tput civis

    # Set the rotating symbol strings
    local sym="$(symbolarray mini)";
    syms=("$sym" "$sym" "$sym")

    # Load a symbol string into an array
    IFS=' ' read -ra sym <<< "$sym"
    symbolsize=${#sym[@]}
    help='WELCOME!'
    drawScreen;
}

drawScreen () {
    screen="$(initui mini)"
    screen=$(replacestring "$coins" '<C>' "$screen")
    screen=$(replacestring "$help" '<message-------->' "$screen")
    
    local i j
    for i in {0..2} ; do
        # Parse the correct column array to a string
        local sym
        IFS=' ' read -ra sym <<< "${syms[$i]}"

        for j in {1..3} ; do
            # Select a symbol and locator, and add it to the screen
            symbol="${sym[$(($j-1))]}"
            locator="<$(($i*3+$j))>"
            screen=$(replacestring "$symbol" "$locator" "$screen")
        done
    done
    drawer "$screen"
}

# ROTATE GIVEN COLUMNS, 1 SYMBOL AT A TIME #
rotate () {
    # Limit and check parameters
    if [ -z $1 ] || [ $# -gt 25 ] ; then return 1; fi;

    local i len;
    # Loop over all provided function arguments, which correspond to columns (may contain the same column multiple times), up to 25 columns total (this is an arbitrary limit)
    for ((i=1;i<$(($#+1));i++)) ; do
        # Find the correct column based on the currently considered argument
        col=$((${@:$i:1}-1))

        # Skip if the selected column is out of scope, NOT DYNAMIC YET
        if [ $col -lt 0 ] || [ $col -ge 3 ] ; then continue; fi;

        # Parse the string of the right column into an array
        local sym
        IFS=' ' read -ra sym <<< "${syms[$col]}"
        
        # Shift the symbol array by removing the first symbol and appending it to the end.
        # Then parse it to a string and replace the old column string by the new one
        syms[$col]="${sym[@]:1} ${sym[@]:0:1}"
    done
}

pull () {
    minicrank
    help='ROLLING'
    coins=$(($coins-1));
    random[0]=$(($RANDOM % $symbolsize + $symbolsize*$speed))
    random[1]=$(($RANDOM % $symbolsize + $symbolsize*$speed))
    random[2]=$(($RANDOM % $symbolsize + $symbolsize*$speed))
    for ((i=1;i<${random[0]};i++)) ; do
        rotate 1 2 3;
        drawScreen;
        sleep 0.05;
    done;
    for ((i=1;i<${random[1]};i++)) ; do
        rotate 2 3;
        drawScreen;
        sleep 0.05;
    done;
    for ((i=1;i<${random[2]};i++)) ; do
        rotate 3;
        drawScreen;
        sleep 0.05;
    done;
    for i in {0..2} ; do
        local sym
        IFS=' ' read -ra sym <<< "${syms[$i]}"
        res[$i]="${sym[1]}"
    done
}

# Calculate the result of a roll and draw them to the screen
result () {
    if [ "${res[0]}" == "${res[1]}" -a "${res[1]}" == "${res[2]}" ] ; then
        # All three symbols are the same
        if [ "${res[0]}" == '7' ] ; then
            help='JACKPOT!'
            coins=$(($coins+100))
        else
            help='BIG PRICE!'
            coins=$(($coins+10))
        fi
    else
        if [ "${res[0]}" == "${res[1]}" -o "${res[1]}" == "${res[2]}" -o "${res[0]}" == "${res[2]}" ] ; then
            # 2 symbols are the same
            help='SMALL PRICE!'
            coins=$(($coins+3))
        else
            # No symbols are the same
            help='NO PRICE!'
        fi
    fi
}
# Run the game loop
run () {
    initialize;
    clear;
    drawScreen;
    echo "PRESS ENTER TO PLAY!"
    while [ $coins -gt 0 ] ; do
        read;
        pull;
        result;
        ### TODO: save game state by writing values to a file ###
        drawScreen;
    done
    help='GAME OVER!'
    drawScreen;
    tput cvvis;
}

run;

exit 0
