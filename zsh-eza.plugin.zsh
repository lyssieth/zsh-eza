#!/usr/bin/env zsh

#####################
# COMMONS
#####################
autoload colors is-at-least

#########################
# CONSTANT
#########################
BOLD="bold"
NONE="NONE"

#########################
# Functions
#########################

_zsh_exa_last_version() {
    echo $(curl -s https://api.github.com/repos/eza-community/eza/releases/latest | grep tag_name | cut -d '"' -f 4)
}

_zsh_eza_log() {
    local font=$1
    local color=$2
    local msg=$3
    
    if [ $font = $BOLD ]
    then
        echo $fg_bold[$color] "[zsh-eza-plugin] $msg" $reset_color
    else
        echo $fg[$color] "[zsh-eza-plugin] $msg" $reset_color
    fi
}

_zsh_eza_install() {
    _zsh_eza_log $NONE "blue" "#############################################"
    _zsh_eza_log $BOLD "blue" "Installing eza..."
    local last_version=$(_zsh_eza_last_version)
    _zsh_eza_log $NONE "blue" "-> retrieve last version of eza..."
    cargo install eza
    _zsh_eza_log $NONE "blue" "#############################################"
}

update_zsh_eza() {
    _zsh_eza_log $NONE "blue" "#############################################"
    _zsh_eza_log $BOLD "blue" "Checking new version of eza..."
    
    # take only second line of this command
    local current_version=$(eza --version | sed -n 2p)
    local last_version=$(_zsh_eza_last_version)
    
    if is-at-least ${last_version#v*} ${current_version#v*}
    then
        _zsh_eza_log $BOLD "green" "Already up to date, current version : ${current_version}"
    else
        _zsh_eza_log $NONE "blue" "-> Updating eza..."
        cargo install eza
        _zsh_eza_log $BOLD "green" "Update OK"
    fi
    _zsh_eza_log $NONE "blue" "#############################################"
}

# install eza if it isnt already installed
[[ ! -f "${zsh_eza_VERSION_FILE}" ]] && _zsh_eza_install

# load eza if it is installed
if [[ -f "${zsh_eza_VERSION_FILE}" ]]; then
    _zsh_eza_load
fi


########################################################
##### ALIASES
########################################################
alias ll='eza -lbF --git --git-repos'
alias la='eza -lbhHigmuSa --time-style=long-iso --git --git-repos --color-scale'
alias lx='eza -lbhHigmuSa@ --time-style=long-iso --git --git-repos --color-scale'
alias llt='eza -l --git --git-repos --tree'
alias lt='eza --tree --level=2'
## Sorts
alias llm='eza -lbGF --git --git-repos --sort=modified'
alias lld='eza -lbhHFGmuSa --group-directories-first'
