# zmodload zsh/zprof

ARCH=$(/usr/bin/arch)
if [ "$ARCH" = "i386" ]; then
    BREW_BY_PATH="/usr/local/bin/brew"
elif [ "$ARCH" = "arm64" ]; then
    export PATH="/opt/homebrew/bin:$PATH"
    BREW_BY_PATH="/opt/homebrew/bin/brew"
else
    echo "Unable to determine hombrew path for arch: $ARCH"
    BREW_BY_PATH="brew"
fi

# Load local environment settings, like special private/work aliases (pbrun, etc.)
if [ -f ~/.zshcustom ]; then
    echo "Using zshcustom"
    source ~/.zshcustom
fi

# We'll need brew before anything else can work
if [ ! -x $BREW_BY_PATH ]; then
    echo "Prompting for password to install Hombrew"
    if [ "$ARCH" = "i386" ]; then
        sudo chown -R $(whoami): /usr/local/share/zsh
    fi
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Download zinit if it doesn't already exist
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}zinit%F{220}…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
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



# We are going to use starship for a prompt since it's fast and powerful
if ! command -v starship &> /dev/null; then
    $BREW_BY_PATH install starship
fi
eval "$(starship init zsh)"

# Handle some additional kakoune install stuff if we need it
if ! command -v kak &> /dev/null; then
    $BREW_BY_PATH install kakoune
fi
if [ ! -d "$HOME/.config/kak/plugins" ]; then
    mkdir -p "$HOME/.config/kak/plugins/"
fi
if [ ! -d "$HOME/.config/kak/plugins/plug.kak" ]; then
    git clone https://github.com/robertmeta/plug.kak.git ~/.config/kak/plugins/plug.kak
    echo "$(tput bold)Don't forget to run 'plug-install' in Kakoune!$(tput sgr0)"
fi

# zprof
