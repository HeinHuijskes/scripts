#!/bin/bash


# Check that the number of arguments is sufficient
if [ -z $1 ] ; then
    echo 'Please provide a name for the new script'
    exit 1
fi
name=$1


# Check whether this name is already in use
cd $HOME/scripts/bash
if [ -f "$name.sh" ] ; then
    echo "Script with name '$name' already exists"
    exit 1
fi


# Create new files for the script and it's description
temp="$(cat 'template.txt')"
replace='{-file-}'
touch "$name.sh"
touch "./help/$name.txt"
chmod 700 "$name.sh"
chmod 600 "help/$name.txt"
echo "${temp/$replace/$1}" >> "$name.sh"
echo "$name" >> "help/$name.txt"
echo "Succesfully created new script '$name.sh' at '$PWD'"


# Try to create an alias using the script name or a provided name
alias=$name
if [ -n "$2" ] ; then 
    alias=("${2[@]}");
fi
bash addalias.sh "$name.sh" $alias  1>/dev/null;
if [[ $? -eq 0 ]] ; then
    echo "Succesfully created new alias '$alias'";
fi
exit 0
