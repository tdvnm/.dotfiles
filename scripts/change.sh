#!/bin/bash

if [[ $1 = 'nvm' || $1 = '1' ]]; then
    echo "nvim"
    echo "you wanna continue "

    cp -r ~/.config/nvim/* ~/config/nvim/
    echo "content copied"
    echo "   "
    cd ~/config/
    git.sh

elif [[ $1 = 'scr' || $1 = '2' ]]; then
    cp -r ~/dev/scripts/* ~/config/scripts/
    echo "content copied"
    echo "   "
    cd ~/config/
    git.sh

elif [[ $1 = 'fsh'|| $1 = '3' ]]; then 
    cp ~/.config/fish/config.fish ~/config/fish/config.fish
    echo "updated config file"
    echo "   "
    cd ~/config/ 
    git.sh

elif [[ $1 = 'tmx' || $1 = '4' ]]; then 
    cp -r ~/.tmux.conf ~/.tmux.conf.local ~/.tmux/ ~/config/tmux/
    echo "updated config file"
    echo "   "
    cd ~/config/ 
    git.sh

elif [[ $1 = 'kty' || $1 = '5' ]]; then 
    cp ~/.config/kitty/kitty.conf ~/config/kitty/kitty.conf
    echo "updated config file"
    echo "   "
    cd ~/config/ 
    git.sh

elif [[ $1 = '-h' || $1 = '--help' ]]; then 
    echo "choose"
    echo "1. nvim"
    echo "2. script"
    echo "3. fish"
    echo "4. tmux"
    echo "5. kitty"
    change.sh

# else
#     nvim ~/dev/scripts/
fi
