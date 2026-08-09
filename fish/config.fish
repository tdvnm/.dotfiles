function fish_greeting
    nerdfetch
end

# vim mode
fish_vi_key_bindings

function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cF forward-char
    end
end

# shortcuts
alias sudo "sudo "
alias snv "sudoedit "
alias clr "clear"
alias md "mkdir"
alias rf "rm -rf"
alias nv "nvim"
alias nvconf "nv ~/.config/nvim/"
alias pdfv "zathura"
alias torb "tor-browser"

# my dotfiles repo
alias dot "cd ~/.config/.dotfiles"

# c++
alias cum "g++ -std=c++17 "
alias cumass "g++ -Wall -Wextra -Wconversion -Wsign-conversion "

# latex
alias texcompile "latexmk -pdf -lualatex -interaction=batchmode -f "

set -gx EDITOR nvim
set -gx SUDO_EDITOR nvim
set -gx BROWSER firefox

# never write foo:$PATH in here. $PATH is a list so fish pastes foo: onto
# every single element instead of prepending once, and it multiplies every
# time this file gets sourced. thats how i ended up with 72 entries and
# texlive 2023 sitting in there 48 times. fish_add_path is idempotent
fish_add_path -g ~/.local/bin
fish_add_path -g ~/.config/emacs/bin

function tanvi
    bash ~/code/tanvi/start.sh
end
