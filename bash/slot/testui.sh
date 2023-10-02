#!/bin/bash


# var=$(bash slotui.sh -d initui)
# bash slotui.sh -d draw "${var[@]}"
# bash slotui.sh -d crank
# bash slotui.sh -d reversecrank

var=$(bash slotui.sh -d initui); bash slotui.sh -d draw "${var[@]}"; bash slotui.sh -d crank; bash slotui.sh -d reversecrank

sleep 0.5

clear

bash slotui.sh -d initui mini
