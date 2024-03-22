function fish_greeting
end

# vim mode
fish_vi_key_bindings

# autocomplete
function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cF forward-char
    end
end

# shortcuts
alias clr "clear"
alias md "mkdir"
alias rf "rm -rf"
alias nv "nvim"

alias nvconf "nv ~/.config/nvim/"

# git alias
alias gitall "git.sh"

# directory aliases
alias dev "cd ~/dev"
alias cpp "cd ~/dev/cpp/learncpp/"
alias dsa "cd ~/dev/dsa/"
alias mat "cd ~/math"

alias c "cd ~/dev/c/"

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

set fish_color_valid_path
# Created by `pipx` on 2023-03-03 10:34:25
set PATH $PATH /home/cshubhro/.local/bin
set -x PATH /usr/local/node-v18.15.0-linux-x64/bin $PATH
set -x  PATH /usr/local/texlive/2023/bin/x86_64-linux:$PATH 

# Bash scripts
set PATH $PATH /home/shubhro/dev/scripts/

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# launchers
alias torb "flatpak run com.github.micahflee.torbrowser-launcher"
