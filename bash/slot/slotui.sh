#!/bin/bash

function="None"
explanation="TUI for slot machine
OPTIONS:

  -h
    Show this explanation

  -d [arg]
     
     initui (mini)
       Initializes the ui and returns it as a string. Use option mini for the smaller ui.
     
     draw [arg]
       Clears the screen and draws the ui provided as an argument to the screen. 'initui' can be piped into this directly.
     
     crank (mini)
       Draws the crank animation on the screen. Presumes that a ui is already drawn to the screen, although this is not necessary.
       
     reversecrank (!mini)
       Same as crank, but in the opposite direction. Not yet functional for small ui"

while getopts "hd:" opt ; do
    case $opt in 
        h) # Display help
            # TODO: Expand help text to show different options
            echo "$explanation";
            exit
            ;;
        d)  # Determine what function to call
            function="$OPTARG"
            ;;
    esac
done

initui () {
    fileloc="slot.txt"
    if [ "$1" = "mini" ] ; then
        fileloc="minislot.txt"
    fi

    IFS=''
    index=0
    while read -r line; do
        ui[$index]="$line"
        index=$((index+1))
    done < $fileloc
    IFS=$'\n'; ui="${ui[*]}"
    echo "${ui}"
}

draw () {
    clear
    readarray -t ui <<< "${1}"
    for string in "${ui[@]}" ; do
        printf "${string}\n"
    done
}

minicrank() {
    scrlen=24
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
        
        sleep 0.05;
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
        
        sleep 0.05;
    done
    return;
}

crank() {
    if [ "$1" = "mini" ] ; then
        minicrank
        return 1;
    fi
    
    crankstart=9
    scrlen=80
    head="(  )"
    shaft=" __ "
    clear="    "

    for i in {2..19} ; do
        if [ $i -eq 10 ] ; then
            shaft="\\__ "
            head="(__)"
        fi
        if [ $i -eq 11 ] ; then
            shaft=" \\  "
            clear="\\   "
        fi
        if [ $i -eq 12 ] ; then
            shaft="/|\\ "
        fi
        if [ $i -eq 13 ] ; then
            shaft=" || "
        fi

        tput cup $((crankstart+i-1)) $scrlen
        printf "$shaft"
        tput cup $((crankstart+i)) $scrlen
        printf "$head"
        
        if [ $i -le 11 ] ; then
            tput cup $((crankstart+i-2)) $scrlen
            printf "$clear"
        fi
        
        sleep 0.01
    done
}

reversecrank() {
    # TODO: perhaps merge crank and reversecrank using the array method `shafts` uses below
    shafts=("    " "/   " " /  " "\\|/ " " || ")
    crankstart=9
    scrlen=80

    head="(__)"
    shaft=${shafts[0]}
    clear="    "

    for i in {2..19} ; do
        if [ $i -eq 10 ] ; then
            shaft="${shafts[1]}"
            clear="\\__ "
        fi
        if [ $i -eq 11 ] ; then
            head="(  )"
            shaft="${shafts[2]}"
            clear=" __ "
        fi
        if [ $i -eq 12 ] ; then
            shaft="${shafts[3]}"
        fi
        if [ $i -eq 13 ] ; then
            shaft="${shafts[4]}"
        fi

        tput cup $((crankstart+20-i+1)) $scrlen
        printf "$shaft"
        tput cup $((crankstart+20-i)) $scrlen
        printf "$head"
        
        if [ $i -ge 10 ] ; then
            tput cup $((crankstart+20-i-1)) $scrlen
            printf "$clear"
        fi
        
        sleep 0.01
    done
}


if [ "$function" = "None" ] ; then
    return 0
fi

functions=("initui" "draw" "crank" "reversecrank")
for fun in ${functions[@]}; do
    if [ "$function" = "$fun" ] ; then
        $function "$3"
    fi 
done

