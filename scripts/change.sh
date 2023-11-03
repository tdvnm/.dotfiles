#!/bin/bash

if [ $1 = '1' ]; then
    cp ~/.config/nvim/* ~/config/nvim/
    echo "content copied"
    echo "   "
    cd ~/config/
    git.sh

elif [ $1 = '2' ]; then
    cp -r ~/dev/scripts/* ~/config/scripts/
    echo "content copied"
    echo "   "
    cd ~/config/
    git.sh

elif [ $1 = '3' ]; then 
    cp ~/.config/fish/config.fish ~/config/fish/config.fish
    echo "updated config file"
    echo "   "
    cd ~/config/ 
    git.sh

elif [ $1 = '4' ]; then 
    cp -r ~/.tmux.conf ~/.tmux.conf.local ~/.tmux/ ~/config/tmux/
    echo "updated config file"
    echo "   "
    cd ~/config/ 
    git.sh

elif [ $1 = '5' ]; then 
    cp ~/.config/kitty/kitty.conf ~/config/kitty/kitty.conf
    echo "updated config file"
    echo "   "
    cd ~/config/ 
    git.sh

elif [ $1 = '-h' ]; then 
    echo "choose"
    echo "1. nvim"
    echo "2. script"
    echo "3. fish"
    echo "4. tmux"
    echo "5. kitty"
    change.sh

else
    nvim ~/dev/scripts/
fi
