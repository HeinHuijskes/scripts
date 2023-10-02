#!/bin/bash


location="./logs.txt"

while getopts ":hcs" opt ; do
    case $opt in 
        h) # Display help
            echo "debugger";
            exit;;
        c)
            echo "" > "${location}"
            exit;;
        s)
            cat ${location}
            exit;;
    esac
done

touch $location
for ((i=1;i<$(($#+1));i++)) ; do
    string="${@:$i:1}"
    echo "${string}" >> "${location}" 2>/dev/null;
done
