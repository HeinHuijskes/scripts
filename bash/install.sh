#!/bin/bash

programs=$(cat ~/scripts/install.txt)
program=''
for prgm in ${programs[@]}
do
   existing=$(which $prgm)
   if [ -z "$existing" ] ; then
      echo "installing $prgm";
      sudo apt install $prgm;
   else
      echo "$prgm already installed: ${existing[@]}";
   fi
   program='';
done
