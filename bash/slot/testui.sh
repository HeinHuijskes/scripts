#!/bin/bash

clear

expected="Hello this is a   test   string"
actual=$(bash slotui.sh -d replacestring 'test' '<locate>' 'Hello this is a <locate> string')
bash test.sh "$expected" "$actual"

sleep 2

var=$(bash slotui.sh -d initui); 
bash slotui.sh -d drawer "${var[@]}"; 
bash slotui.sh -d crank; 
bash slotui.sh -d reversecrank

sleep 1

clear

bash slotui.sh -d initui mini;
bash slotui.sh -d crank mini;
