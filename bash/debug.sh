#!/bin/bash


location="debug-logs"
path="$HOME/scripts/bash/logs"

while getopts ":hcs" opt ; do
    case $opt in 
        h) # Display help
            echo $HOME/scripts/bash/help/debug;
            exit;;
        c)
            echo "" > "${path}/${location}"
            exit;;
        s)
            cat ${path}/${location}
            exit;;
    esac
done

for ((i=1;i<$(($#+1));i++)) ; do
    string="${@:$i:1}"
    echo "${string}" >> "${path}/${location}" 2>/dev/null;
done
