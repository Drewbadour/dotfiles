# zmodload zsh/zprof

# Download zinit if it doesn't already exist
if [[ ! -f "${HOME}/.zinit/bin/zinit.zsh" ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}zinit%F{220}…%f"
    command mkdir -p "${HOME}/.zinit" && command chmod g-rwX "${HOME}/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "${HOME}/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ Installation failed.%f%b"
fi



# Source zinit and get it going
source "${HOME}/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Steal some plugins from ohmyzsh
# Improve history and key bindings
# Allows partial completion on arrow up, for example
# Need these immediately
zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh

# Adds better completion features like case-insensitive completion
# Which is nice since APFS is case-insensitive by default
zinit ice atload'zicompinit'
zinit snippet OMZL::completion.zsh


# Load up the aliases files
if [[ -f "${HOME}/.aliases.zsh" ]]; then
    print "Loading aliases."
    source "${HOME}/.aliases.zsh"
fi

# Load OS-specific features
local UNAME_VAL=$(uname -s)
print "Loading ${UNAME_VAL} configurations."
source "${HOME}/.${UNAME_VAL}.zsh"
unset UNAME_VAL

# Load WSL-specific features on top of Linux-specific ones
if [[ -f /proc/version && "$(</proc/version)" == *microsoft* ]]; then
    print "Loading WSL configurations."
    source "${HOME}/.WSL.zsh"
fi



eval "$(starship init zsh)"

# zprof
