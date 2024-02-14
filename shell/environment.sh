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
c_reset='\[\e[0m\]'
c_path='\[\e[0;31m\]'
c_git_clean='\[\e[0;32m\]'
c_git_dirty='\[\e[0;31m\]'
BLUE="\[\033[1;34m\]"
COLOR_NONE="\[\e[0m\]"

# Set Python virtualenv in prompt if active
__set_virtualenv

# Configure prompt
export PROMPT_COMMAND='PS1="${c_path}\W${c_reset}$(__git_prompt) :> "'
export PS1='\n\[\033[0;31m\]\W\[\033[0m\]$(__git_prompt)\[\033[0m\]:> '

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