#!/bin/bash

while getopts ":h" opt ; do
    case $opt in 
        h) # Display help
            echo 'just saying hi';
            exit;;
    esac
done

if [ $# -eq 1 ] && [ "$1" = "there"  ] ; then 
    echo "general kenobi"; 
else
    echo 'hi';
fi

exit 0
