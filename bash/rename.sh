#!/bin/bash

while getopts ":h" option ; do
    case $option in 
        h) # Display help
            cat $HOME/scripts/bash/help/rename.txt;
            exit;;
    esac
done



if [ -z $1 ] || [ -z $2 ] ; then
    echo 'Please provide the folder location and the new file extension';
    exit 1;
fi

loc="$1"
new="$2"
old="$3"
cd $loc;
if [ ! $? -eq 0 ] ; then echo 'Unknown location'; exit 1; fi

for file in * ; do
    if [ ! -f $file ] ; then continue; fi;
    if [ -n "$old" ] ; then
        if [ "${file}" != "${file%$old}" ] ; then
            mv $file "${file%.$old}.$new";
        fi
    else
        if [ "$file" = "${file%.*}" ] ; then
            mv $file "$file.$new"
        fi
    fi
done
