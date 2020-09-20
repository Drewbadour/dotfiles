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

# Colorless/git-less prompt to use while prompt loads in the background
PS1="➜  %c%  "

# Steal some plugins from ohmyzsh
# Sublime lets me use "st" to launch sublime text from the terminal, but I don't really want the other stuff
zinit wait lucid for \
	atload"unalias stp; unalias stn; unfunction find_project; unfunction create_project" \
		OMZP::sublime

# Improve history and key bindings
# Allows partial completion on arrow up, for example
zinit wait lucid for \
	OMZL::history.zsh \
	OMZL::key-bindings.zsh

# Adds better completion features like case-insensitive completion
# Which is nice since APFS is case-insensitive by default
zinit wait lucid atload'zicompinit' for \
	OMZL::completion.zsh

# Install all of the stuff we need for our prompt
# Git for git status, colors for colors, and then finally the prompt itself
# Need the wait'!' for reloading the prompt when we are done
zinit wait'!' lucid for \
	OMZL::git.zsh \
	OMZL::theme-and-appearance.zsh \
	OMZT::robbyrussell
