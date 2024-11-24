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

if [ -n "$ZSH_VERSION" ]; then
    # ZSH colors
    BLUE="%F{blue}"
    COLOR_NONE="%f"
else
    # Bash colors
    BLUE="\[\033[1;34m\]"
    COLOR_NONE="\[\e[0m\]"
fi

# Set virtualenv prompt with zsh/bash compatibility
__set_virtualenv() {
   if [ -n "$VIRTUAL_ENV" ]; then
       if [ -n "$ZSH_VERSION" ]; then
           PYTHON_VIRTUALENV="%F{blue}[$(basename "$VIRTUAL_ENV")]%f "
       else
           PYTHON_VIRTUALENV="${BLUE}[$(basename "$VIRTUAL_ENV")]${COLOR_NONE} "
       fi
   else
       PYTHON_VIRTUALENV=""
   fi
}


__git_prompt() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        return 0
    fi
    git_branch=$(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')
    if [ -n "$ZSH_VERSION" ]; then
        if git diff --quiet 2>/dev/null >&2; then
            echo " [%F{green}${git_branch}%f]"
        else
            echo " [%F{red}${git_branch}%f]"
        fi
    else
        # Bash version stays the same
        if git diff --quiet 2>/dev/null >&2; then
            echo " [\[\033[0;32m\]${git_branch}\[\033[0m\]]"
        else
            echo " [\[\033[0;31m\]${git_branch}\[\033[0m\]]"
        fi
    fi
}

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