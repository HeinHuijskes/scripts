#!/bin/bash

cd $HOME/scripts

# Check that the number of arguments is sufficient
if [ -z $1 ] ; then
    echo 'Please provide a name for the alias to remove'
    exit 1
fi

temp="alias $1="
location='~/.bash_aliases'
aliases=$(cat "$location")
replace=$(cat "$aliases" | grep $temp)
echo "${aliases/$replace}" > $location
