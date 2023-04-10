#!/bin/bash


# Check that the number of arguments is sufficient
if [ -z $1 ] ; then
    echo 'Please provide the name of the script to add an alias for'
    exit 1
fi
if [ -z $2 ] ; then
    echo 'Please provide the name of the new alias'
    exit 1
fi


# Check that the script to add an alias for actually exists
cd $HOME/scripts/bash
if [ ! -f $1 ] ; then
    echo "No script found with name $1. Perhaps try using autocomplete"
    exit 1
fi

# Add the alias
loc="$HOME/.bash_aliases"
# The expression below only consideres aliases in ~/scripts/.bash_aliases, not systemwide.
exists=$(cat $loc | grep ^"alias ${2}=")
isprgm=$(which $2)
if [ -n "$exists" ] || [ -n "$isprgm" ] ; then
    echo "An alias or command with name '$2' already exists"
    exit 1
else
    echo "alias $2='bash ~/scripts/bash/$1'" >> $loc
fi


echo "Succesfully created new alias '$2' for bash script '$1'"
exit 0
