#!/bin/bash

expected=$1
actual=$2
printf "Expected: $expected\n"
printf "Actual: $actual\n"
if [ "$expected" = "$actual" ] ; then
    echo "Success!"
else
    echo "Failed!"
fi
