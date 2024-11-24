#!/bin/bash

# Guard against multiple sourcing
if [ -n "$ENVIRONMENT_LOADED" ]; then
    return
fi
export ENVIRONMENT_LOADED=1

#
# Prompt Configuration
#
# Color definitions for git prompt and PS1
c_reset="\e[0m"
c_path="\e[0;31m"
c_git_clean="\e[0;32m"
c_git_dirty="\e[0;31m"
BLUE="\e[1;34m"
COLOR_NONE="\e[0m"

# Set virtualenv prompt
__set_virtualenv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        PYTHON_VIRTUALENV="${BLUE}[$(basename "$VIRTUAL_ENV")]${COLOR_NONE} "
    else
        PYTHON_VIRTUALENV=""
    fi
}

# Function to get the git prompt
__git_prompt() {
    local git_status="$(git status --porcelain 2>/dev/null)"
    if [ -n "$git_status" ]; then
        echo -e "${c_git_dirty}±${c_reset}"
    else
        echo -e "${c_git_clean}✓${c_reset}"
    fi
}

# prompt.sh
if [ -n "$ZSH_VERSION" ]; then
    # ZSH version
    PS1=$'\n%F{red}%1~%f$(__git_prompt)%f :> '
elif [ -n "$BASH_VERSION" ]; then
    # Bash version
    PS1='\n\[\033[0;31m\]\W\[\033[0m\]$(__git_prompt)\[\033[0m\]:> '
fi

#
# Path Management
#
pathappend() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

# Core paths
pathappend "/opt/homebrew/bin"
pathappend "/opt/homebrew/sbin"
pathappend "/usr/local/bin"
pathappend "/usr/local/sbin"

# Development tools
pathappend "/usr/local/go/bin"
pathappend "$HOME/.cargo/bin"
pathappend "/usr/local/opt/coreutils/libexec/gnubin"

# Personal binaries and tools
pathappend "$HOME/bin"
pathappend "$HOME/.daml/bin"
pathappend "$HOME/.rvm/bin"
pathappend "/usr/local/heroku/bin"

export PATH

# Development Environment
#
# Go configuration
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export GITHUB=$GOPATH/src/github.com
export GO111MODULE=on

# Git GPG signing
export GPG_TTY=$(tty)

# File colors for ls
export LSCOLORS=ExGxFxdxCxDxDxaccxaeex