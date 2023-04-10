#!/bin/bash


# Check that the number of arguments is sufficient
if [ -z $1 ] ; then
    echo 'Please provide a name for the script to remove'
    exit 1
fi
name=$1


# Check whether this name actually exists
cd $HOME/scripts/bash
if [ ! -f "$name.sh" ] ; then
    echo "No script found with name '$name'"
    exit 1
fi


# Remove script, description and alias
rm "$name.sh"
rm "./help/$name.txt"
bash rmalias.sh

exit 0
