zmodload zsh/zprof

# Load local environment settings, like special private/work aliases (pbrun, etc.)
if [ -f ~/.zshcustom ]; then
    source ~/.zshcustom
fi

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

# Enable parameter expansion for prompt
# Needed for things like color in your prompt
setopt promptsubst

# Colorless/git-less prompt that can be used while prompt loads in the background
# Currently never shown since everything loads synchronously, which is faster than async
PS1="➜  %c%  "

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

# Install all of the stuff we need for our prompt
# Git for git status, colors for colors, and then finally the prompt itself
# Need the wait'!' for reloading the prompt when we are done
zinit snippet OMZL::git.zsh
zinit snippet OMZL::theme-and-appearance.zsh
zinit snippet OMZT::robbyrussell

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

zprof
