# zmodload zsh/zprof

# Load local environment settings, like special private/work aliases (pbrun, etc.)
if [ -f ~/.zshcustom ]; then
    source ~/.zshcustom
fi

# TODO(Drew): Check if starship is installed, and if it isn't, then grab it, a-la zinit

# Download zinit if it doesn't already exist
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}zinit%F{220}…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ Installation failed.%f%b"
fi

# Source zinit and get it going
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Steal some plugins from ohmyzsh
# Sublime lets me use "st" to launch sublime text from the terminal, but I don't really want the other stuff
zinit ice atload"unalias stp; unalias stn; unfunction find_project; unfunction create_project"
zinit snippet OMZP::sublime

# Improve history and key bindings
# Allows partial completion on arrow up, for example
# Need these immediately
zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh

# Adds better completion features like case-insensitive completion
# Which is nice since APFS is case-insensitive by default
zinit ice atload'zicompinit'
zinit snippet OMZL::completion.zsh




# Better ls to show the normal stuff
# A - Almost all, I don't need to see . and ..
# q - Don't let control characters mess with my ls
# 1 - Everything on a new line instead of column
alias ll="ls -Aq1"

# Custom ls to show all details
# A - Alsmot all, I don't need to see . and ..
# h - More human readable sizes
# l - Love that list view
# q - Don't let control characters mess with my ls
alias la="ls -Ahlq"

if !command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# We are going to use starship for a prompt since it's fast and powerful
if ! command -v starship &> /dev/null; then
    brew install starship
fi
eval "$(starship init zsh)"

# Handle some additional kakoune install stuff if we need it
if ! command -v kak &> /dev/null; then
    brew install kakoune
fi
if [ ! -d "$HOME/.config/kak/plugins" ]; then
    mkdir -p "$HOME/.config/kak/plugins/"
fi
if [ ! -d "$HOME/.config/kak/plugins/plug.kak" ]; then
    git clone https://github.com/robertmeta/plug.kak.git ~/.config/kak/plugins/plug.kak
    echo "$(tput bold)Don't forget to run 'plug-install' in Kakoune!$(tput sgr0)"
fi

# zprof
