
# Personal bin, so as not to use the system one
LOCAL_BIN="${HOME}/.local/bin"

# Force our brew path on top of everything.
# Other homebrew installs are effectively ignored and should be deleted before adding this .zshrc
USE_SECURE_BREW=true
BREW_BIN="${HOME}/.local/homebrew/bin"
BREW_BY_PATH="${BREW_BIN}/brew"

# Load local environment settings, like special private/work aliases (pbrun, etc.)
if [[ -f "${HOME}/.custom_mac.zsh" ]]; then
    echo "Using .custom.zsh"
    source "${HOME}/.custom_mac.zsh"
fi

if [[ "${USE_SECURE_BREW}" == true ]]; then

    # Create .local and friends if they don't exist
    if [[ ! -d "${LOCAL_BIN}" ]]; then
        mkdir -p "${LOCAL_BIN}"
    fi

    # Use our custom local location:
    # https://gist.github.com/pudquick/29bc95b6c49703992981864e48f8e341#optional-beginnings
    export PATH="${HOME}/.local/bin:${PATH}"

    # We'll need brew before anything else can work
    # https://gist.github.com/pudquick/29bc95b6c49703992981864e48f8e341#the-real-trick
    if [[ ! -x "${BREW_BY_PATH}" ]]; then
        pushd -q "${HOME}/.local/"
        mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
        popd -q
    fi

    # Outsmart homebrew by accessing it via alias.
    # https://gist.github.com/pudquick/29bc95b6c49703992981864e48f8e341#but-dont-just-link-it-into-or-adjust-your-path
    alias brew="${HOME}/.local/homebrew/bin/brew"

else

    # Else, just let homebrew have control of the system.
    if [[ ! -x "${BREW_BY_PATH}" ]]; then
        echo "Prompting for password to install Hombrew"
        if [ "$ARCH" = "i386" ]; then
            sudo chown -R $(whoami): /usr/local/share/zsh
        fi
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

fi




# Properly setup Sublime Text's 'subl' only if using .local
if [[ -d "${LOCAL_BIN}" ]]; then

    # If not already linked, link it to our local bin.
    if [[ ! -x "${LOCAL_BIN}/subl" ]]; then
        # Only link if we can find the Application!
        if [[ -f "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ]]; then
            ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" "${LOCAL_BIN}"
        fi
    fi


    # If we've managed to link subl, then add some shortcuts
    if [[ -x "${LOCAL_BIN}/subl" ]]; then
        export EDITOR=(subl -w)
        alias st="subl"
    else
        # Else, fallback to vim.
        export EDITOR="vim"
    fi

fi




# A bunch of helper functions for "better brew" aka "bb"
function bb-install() {
    # NOTE(Drew): Intentionally does not link.
    brew install --build-from-source $(brew deps --include-build $1) $1
}

function bb-link() {

    local FILE="${BREW_BIN}/${1}"

    if [[ ! -f "${FILE}" ]]; then
        print "${FILE} does not exist to be linked."
        return ENOENT
    fi

    if [[ ! -x "${FILE}" ]]; then
        print "${FILE} exists but is not executable. Cowardly refusing to link."
        return EACCES
    fi

    if [[ -f "${LOCAL_BIN}/${1}" ]]; then
        print "${1} is already linked. Cowardly refusing to copy over it."
        return EACCES
    fi

    ln -s "${BREW_BIN}/${1}" "${LOCAL_BIN}"

    print "Reloading .zshrc..."
    source "${HOME}/.zshrc"
}

function bb-unlink() {

    if [[ ! -L "${LOCAL_BIN}/${1}" ]]; then
        print "${LOCAL_BIN}/${1} does not exist to be unlinked."
        return ENOENT
    fi

    rm -rf "${LOCAL_BIN}/${1}"
}

function bb-unlinked() {

    local SRC_FILE="${BREW_BIN}/${1}"
    local DEST_FILE="${LOCAL_BIN}/${1}"

    if [[ ! -f "${SRC_FILE}" ]]; then
        print "Homebrew's ${SRC_FILE} does not exist."
        return ENOENT
    fi

    if [[ ! -x "${SRC_FILE}" ]]; then
        print "Homebrew's ${SRC_FILE} exists but is not executable."
        return EACCES
    fi

    if [[ ! -f "${DEST_FILE}" ]]; then
        print "${1} exists and is not linked."
        return 0
    fi

    if [[ ! -x "${DEST_FILE}" ]]; then
        print "Local ${DEST_FILE} exists, but is not executable."
        return EACCES
    fi

    print "${1} exists and has already been linked.";
}




# Functions to manage python venvs (and the tools they might need)
function project() {

    local ITEM=${1}
    local VIRTENV_PATH="${HOME}/.local/virtualenvs"
    local VIRTDEP_PATH="${HOME}/.local/virtualdeps"

    if [[ ! -d "${VIRTENV_PATH}/${ITEM}" ]]; then
        print "No virtualenv exists for name ${ITEM}."
    else
        source "${VIRTENV_PATH}/${ITEM}/bin/activate"
    fi


    if [[ -d "${VIRTDEP_PATH}/${ITEM}" ]]; then
        export PATH="${VIRTDEP_PATH}/${ITEM}/bin:${PATH}"
        print "Adding additional items to path."
    else
        print "No additional path items found."
    fi

    export CUR_PROJECT="${ITEM}"

    cd ${HOME}/Projects/${ITEM}
}
# Completions for the "project" function
# Basically just suggests the contents of ${HOME}/Projects
_project() {
    # Avoid using "files:filename:_files -/ -W ${HOME}/Projects/"
    # so it doesn't give further directory pathing.
    # Just want those top-level directory names as args.
    _alternative "arguments:custom arg:($(ls ${HOME}/Projects/))"
}
compdef _project project

# Links a brew dep to a project via its virtual dependencies
# Arg 1 - Dep
# Arg 2 - Project
function project-link() {

    local DEP=${1}
    local BREW_DEP=`brew --prefix ${DEP}`

    local PROJECT=${2}
    local VIRTDEP_PATH="${HOME}/.local/virtualdeps"

    # TODO(Drew): Do I need more than this?
    local COPY_DIRS=( bin )

    if [[ ! -d "${VIRTDEP_PATH}/${PROJECT}" ]]; then
        print "No virtual dependency folder exists for this project. Cowardly refusing to make it, assuming you've typo-ed."
        return ENOENT
    fi

    if [[ ! -d "${BREW_DEP}" ]]; then
        print "Couldn't find ${DEP} at ${BREW_DEP}, so it cannot be linked."
        return ENOENT
    fi

    for FOLDER in ${COPY_DIRS}; do

        local FOLDER_PATH="${VIRTDEP_PATH}/${PROJECT}/${FOLDER}"

        if [[ ! -d "${FOLDER_PATH}" ]]; then
            mkdir "${FOLDER_PATH}"
        fi

        # Symbolic links all bin contents to virtdep
        ln -s "${BREW_DEP}/bin/"* "${FOLDER_PATH}/"
    done

    print "Linked contents of ${DEP} from ${BREW_DEP} to ${VIRTDEP_PATH}/${PROJECT}"
}

# NOTE(Drew): You make virtualenvs with:
# virtualenv --python="/path/to/python" ~/.local/virtualenvs/project_name




function git-proj-setup() {

    local GPG_LONG_ID

    print -P "%F{green}"
    print "Listing GPG keys, please find the one used for git signing for this project."
    print "Copy the 16 character code on the 'sec' line"
    print -P "%f"
    gpg --list-secret-keys --keyid-format LONG

    print -Pn "%F{green}Paste the long ID:%f "
    read GPG_LONG_ID

    print -P "%F{green}"
    print "Adding value to user.signingkey"
    print -Pn "%f"
    git config user.signingkey ${GPG_LONG_ID}
}

function git-initial-setup() {

    local GPG_LONG_ID

    # For safety, some stuff might not clean up after itself properly, so to be safe:
    stty sane

    # Add git-credential-manager-core to get around stupid tokens
    brew tap microsoft/git
    brew install --cask git-credential-manager-core

    brew install gnupg
    bb-link gpg

    print -P "%F{green}"
    print "Use the configuration:"
    print "\tKind: RSA, sign only"
    print "\tSize: 4096"
    print "\tExpiration: Never"
    print "\tReal Name: Github Username"
    print "\tEmail: Username@users.noreply.github.com"
    print -P "%f"
    gpg --full-generate-key

    print -P "%F{green}"
    print "Adding GPG signing requirement to global settings."
    print -Pn "%f"
    git config --global commit.gpgsign true

    print -P "%F{green}"
    print "Listing GPG keys, please find the one used for git signing for this project."
    print "Copy the 16 character code on the 'sec' line"
    print -P "%f"
    gpg --list-secret-keys --keyid-format LONG

    print -Pn "%F{green}Paste the long ID:%f "
    read GPG_LONG_ID

    print -P "%F{green}"
    print "Paste the following into GitHub:"
    print -Pn "%f"
    gpg --armor --export ${GPG_LONG_ID}
}



# We are going to use starship for a prompt since it's fast and powerful
if ! command -v starship &> /dev/null; then
    "${BREW_BY_PATH}" install starship
    ln -s "${BREW_BIN}/starship" "${LOCAL_BIN}"
fi




# gpg signing configuration for git
# https://gist.github.com/troyfontaine/18c9146295168ee9ca2b30c00bd1b41e
export GPG_TTY=$(tty)
