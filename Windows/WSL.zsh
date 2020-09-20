
## Aliases

# Allows launch of Sublime Text to Windows paths
# Doesn't play nicely with things only in WSL paths
alias st='/mnt/c/Program\ Files/Sublime\ Text/subl.exe'




## Color
# Default to color for a number of commands
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add some color to gcc messages
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'




## Functions
# Windows-based cd. Mostly lets me get into the Windows filesystem quickly.
function cdw() {
    if [[ "${#}" -eq 0 ]]; then
            cd "/mnt/c/Users/$(whoami)/"
    elif [[ "${1}" -eq "-" ]]; then
            cd "${1}"
    else
            cd -- "$(wslpath "${@}")"
    fi

}
