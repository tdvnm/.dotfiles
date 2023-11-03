function fish_greeting
    fm6000
    fortune -a
end

alias sa "sudo apt"

# shortcuts
alias clr "clear"
alias md "mkdir"
alias rf "rm -rf"
alias nv "nvim"
alias nvh "nvim ."
alias ff "firefox"

# directory aliases
alias dev "cd ~/dev"
alias cpp "cd ~/dev/cpp/learncpp/"
alias dsa "cd ~/dev/dsa/"
alias mat "cd ~/math"

# config aliases
alias conf "cd ~/.config/"
alias nvconf "nvim ~/.config/nvim"
alias fishconf "nvim ~/.config/fish/"

# c++ aliases
alias cum "g++ -std=c++17 "
alias cumass "g++ -Wall -Weff++ Wextra -Wconversion -Wsign-conversion "

#latex aliases
alias texcompile "latexmk -pdf -lualatex -interaction=batchmode -f "

# tmux aliases
alias tmls "tmux ls"
alias tmopen "tmux attach-session -t "

# temp college aliases
alias calc "cd ~/math/krea/calc/"
alias ict "cd ~/krea/tr2/ict/"

# Created by `pipx` on 2023-03-03 10:34:25
set PATH $PATH /home/cshubhro/.local/bin
set -x PATH /usr/local/node-v18.15.0-linux-x64/bin $PATH
set -x  PATH /usr/local/texlive/2023/bin/x86_64-linux:$PATH 

# Bash scripts
set PATH $PATH /home/shubhro/dev/scripts/
