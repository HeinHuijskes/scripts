#!/bin/bash

cd $HOME/scripts/bash/completion

echo '#!/bin/bash' > './all'
for file in *.comp ; do
    text=$(< $file)
    echo "${text/'#!/bin/bash'}" >> './all'
done
