#!/bin/bash

# Set up structure
mkdir $HOME/scripts/bash/logs;
mkdir $HOME/scripts/bash/completion;
mkdir $HOME/scripts/bash/help
touch $HOME/scripts/bash/logs/debug-logs


### Replace .bash_aliases while keeping it's contents

cd $HOME
# Check that the file exists and is not a symlink
exists=$(ls -al | grep ^- | grep .bash_aliases)
if [ -n "$exists" ] ; then
   echo 'Adding old bash aliases to new ones'
   echo $HOME/.bash_aliases >> $HOME/scripts/.bash_aliases;
   rm $HOME/.bash_aliases;
else
   echo 'No old bash aliases found'
fi
# Create a symlink 
ln -s $HOME/scripts/.bash_aliases $HOME/.bash_aliases 2>/dev/null;



### Add symlinks for all completion files

echo 'Generating symlink for bash completion'
sudo ln -s ~/scripts/bash/completion/all /etc/bash_completion.d/all

echo 'Activating boot script'
crontab -e
echo '@reboot ~/scripts/bash/onboot.sh'



echo 'Done'

