#!/bin/bash

while getopts ":h" opt ; do
    case $opt in 
        h) # Display help
            echo $HOME/scripts/bash/help/onboot;
            exit;;
    esac
done


