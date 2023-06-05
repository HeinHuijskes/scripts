#!/bin/bash

debugger="$HOME/scripts/bash/debug.sh"
$debugger -c

function log() {
    $debugger ${@};
    $debugger "";
}

### SLOTMACHINE GAME ###
### Bash remake of a small slotmachine game made originally for a graphical calculator
### Probably quite poorly coded, since I am still starting to learn bash
########################

coins=10    # [Number] Number of coins
help=''     # [String] Help text
sym=''      # [String] Symbols on the cards
bet=0       # [Number] Bet amount
screen=''   # [String] Screen display
retval=''   # [?Any] Function return value
speed=2     # [Number] Speed factor, must be a whole number of 0 or higher
res=''      # [Array|String] Result of a pull
scrlen=0    # [Number] Screen string length
stspd=0.02  # [Number] Decimal number describing stick speed
crank=0.1   # [Number] Handle animation speed
erase=0     # [?] Control code for printing
debug=0     # [?] Debug mode
symbols=1   # [?] ?


while getopts "hs:c:d" opt ; do
    case $opt in 
        h) # Display help
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
        d)  # Debug mode
            debug=1
            ;;
    esac
    sleep 1
done

### INTERFACE ###
# Variables:
# Usage: <variable> [type | string length]
#
# <C>       [int|3]  Amount of coins
# <1-9>     [str|3]  Visible slot characters
# <message> [str|17] Message for users (max 17 char)

interface="\
............................
.       SLOTMACHINE        .
.Coins:                 ( ).
.<C>                     | .
.    |[<1>][<4>][<7>]|   | .
.    =================   | .
.    |[<2>][<5>][<8>]|   - .
.    =================     .
.    |[<3>][<6>][<9>]|     .
.                          .
.    <message-------->     .
.                          .
............................
"
#################

initialize () {
    # Hide the cursor
    tput civis

    # Set the rotating symbol strings 
    syms[0]='7-BAR-$-<3-U-0-#-@-(?)';
    syms[1]='7-BAR-$-<3-U-0-#-@-(?)';
    syms[2]='7-BAR-$-<3-U-0-#-@-(?)';

    # Load a symbol string into an array
    IFS='-' read -ra sym <<< "${syms[0]}"
    # Count the number of unique symbols
    symbols=${#sym}
    # Set the initially displayed text
    help='WELCOME!'
    # Set an erase variable that can clear the rest of a line
    erase=$(tput el)
    # Update the screen string, see also the corresponding function setScreen()
    setScreen;
    # Set the screen string width
    scrlen=24
}

# Rotates given columns, 1 character at a time
rotate () {
    # Limit and check parameters
    if [ -z $1 ] || [ $# -gt 25 ] ; then return 1; fi;

    local i len;
    # Loop over all provided function arguments, which are columns (may contain duplicates)
    for ((i=1;i<$(($#+1));i++)) ; do
        # Find the correct column based on the currently considered argument
        col=$((${@:$i:1}-1))
        ###log $col
        # Skip if the selected column is out of scope, NOT DYNAMIC YET
        if [ $col -lt 0 ] || [ $col -ge 3 ] ; then continue; fi;
        # Get the length of the string belonging to the selected column
        len=${#sym[$col]}
        
        # Load the string into a variable
        sym=("${syms[$col]}")
        # Parse the loaded string to an array
        IFS='-' read -ra sym <<< "$sym"

        ###log ${sym[@]}
        
        # Shift the symbol array by removing the first symbol and appending it to the end.
        # Then parse it to a string and replace the old column string by the new one
        syms[$col]="${sym[@]:1:$(($len-1))}${sym[@]:0:1}"
    done
}

# Pad a string correctly
# Expects $1 [string]: the string, and $2 [number]: desired padded string length, where ${#1} <= $2
padString () {
    # Check preconditions
    if [ -z $2 ] || [ ${#1} -gt ${2} ]; then return 1 ; fi;

    local offset padding back;
    # Calculate needed total padding and offsets
    padding=$(($2 - ${#1}));
    offset=$(($padding / 2));
    back=$(($2-$offset));
    # Add offset to the string
    retval=$(printf "%${2}s" "$(printf "%-${back}s" "$1")");
}

getUserInput () {
    ### TODO: IMPLEMENT ###
    if [ -n $1 ] ; then
        echo $1;
    fi
    retval='INPUTTED'
    return 0;
}

# Generate the screen string and set it
setScreen () {
    # Copy the screen template string
    screen="$interface";

    # Add the current amount of coins to the screen
    padString "$coins" 3;
    screen="${screen/<C>/$retval}";
    
    # Add the output text to the screen
    padString "$help" 17;
    screen="${screen/<message-------->/$retval}";

    # Loop over the symbols and add them to the screen
    local i j
    ### TODO: make these loops dynamic ###
    for i in {0..2} ; do
        # Select the correct column
        sym=("${syms[$i]}")
        # Parse the selected column array to a string
        IFS='-' read -ra sym <<< "$sym"

        for j in {1..3} ; do
            # Select a symbol from the string, and pad it
            padString "${sym[$(($j-1))]}" 3;
            # Add the symbol to the screen
            screen="${screen/<$(($i*3+$j))>/"$retval"}";
        done
    done
}

# Draw the current game state to the screen
draw () {
    # Generate the screen from template
    setScreen;
    # Do not reset the cursor position in debug mode
    if [ "$debug" != 1 ] ; then
        tput cup 0 0;
    fi

    local strings string;
    # Parse the screen string to an array of lines
    readarray -t strings <<< "$screen"

    # Print every string to the screen and add a newline
    for string in "${strings[@]}" ; do
        printf "${string}${erase}\n"
    done
}

# Play the stick animation
stickAnimation () {
    if [ $crank == "0" ] ; then
        return 0;
    fi
    tput cup 1 $scrlen
    for i in {2..10} ; do
        tput cup $(($i-1)) $scrlen
        if [ $i -le 7 ] ; then
            if [ $i -eq 7 ] ; then
                printf ' - '
            else
                printf '   '
            fi
        else
            printf ' | '
        fi
        tput cup $i $scrlen
        printf '( )'
        
        sleep $stspd;
    done
    for i in {3..10} ; do
        tput cup $((13-$i)) $scrlen
        if [ $i -le 7 ] ; then
            if [ $i -eq 7 ] ; then
                printf ' - '
            else
                printf '   '
            fi
        else
            printf ' | '
        fi
        tput cup $((12-$i)) $scrlen
        printf '( )'
        
        sleep $stspd;
    done
    return;
}

# Spend a coin to roll once
pull () {
    stickAnimation;
    help='ROLLING'
    coins=$(($coins-1));
    random[0]=$(($RANDOM % $symbols + $symbols*$speed))
    random[1]=$(($RANDOM % $symbols + $symbols*$speed))
    random[2]=$(($RANDOM % $symbols + $symbols*$speed))
    for ((i=1;i<${random[0]};i++)) ; do
        rotate 1 2 3;
        draw;
        sleep $crank;
    done;
    for ((i=1;i<${random[1]};i++)) ; do
        rotate 2 3;
        draw;
        sleep 0.05;
    done;
    for ((i=1;i<${random[2]};i++)) ; do
        rotate 3;
        draw;
        sleep $crank;
    done;
    res[0]="${sym[0]:1:1}"
    res[1]="${sym[1]:1:1}"
    res[2]="${sym[2]:1:1}"
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
    ### TODO: save game state by writing values to a file ###
    draw;
}

# Run the game loop
run () {
    initialize;
    clear;
    draw;
    while [ $coins -gt 0 ] ; do
        read;
        pull;
        result;
    done
    help='GAME OVER!'
    draw;
    tput cvvis;
}

run;

exit 0
