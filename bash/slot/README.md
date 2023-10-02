# README

This is a small slot machine "game" for Linux, developed on Ubuntu, and available on [GitHub](https://github.com/HeinHuijskes/slot). I say "game" here somewhat sarcastically since you can currently only press one button, and it is just stupid luck and gambling. It is a small project that I used to try and improve my bash skills. Like many of these projects it quickly descended into overengineering and adding way too many small things like lever pull animations. 

The new and improved graphics are still being developed, but a sneak peak can be seen in `slot.txt` and by running the ui test. I plan to add many cool little animations to this if I have the time.

## Prerequisites

Your linux distribution needs to be able to run shell scripts with bash. It should be at least a bash version that includes `printf`.

Currently the `slot` folder encasing this project expects to be placed within the following folder hierarchy within your home folder: `~/scripts/bash/slot`. All scripts seen here are placed in that folder. If you want to change this, simply replace the line `cd "$HOME/scripts/bash/slot/"` with the correct folder in the `slot.sh` and `slotui.sh` scripts.

To see if some UI functionality is working, try running `bash testui.sh` from the slot folder. This should print some test results and show some ui animations if everything works.


## Alias

I personally like to add a bash alias to be able to run the game from anywhere. You can easily do this by for instance adding a file titled `.bash_aliases` to your home folder (if it does not already exist). In this file add the line `alias slot='bash ~/scripts/bash/slot/slot.sh'`. Any newly opened terminal should now run the game simply by typing `slot`.


## Author
**Hein Huijskes** brought you these probably not quite so well-written bash scripts in his attempt to better learn the bash language.
