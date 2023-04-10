#!/bin/bash

location='./'
term=("${1}")

if [ "$#" = '2' ] ; then
    location=("${1}");
    term=("${2}");
fi

find $location -iname *$term*
