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
c_reset="%{$reset_color%}"
c_path="%{$fg[red]%}"
c_git_clean="%{$fg[green]%}"
c_git_dirty="%{$fg[red]%}"
BLUE="%{$fg[blue]%}"
COLOR_NONE="%{$reset_color%}"

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
        echo -e " ${c_git_dirty}±${c_reset}"
    else
        echo -e " ${c_git_clean}✓${c_reset}"
    fi
}

# Configure prompt
if [ -n "$BASH_VERSION" ]; then
    PROMPT_COMMAND='__git_prompt; PS1="\n${c_path}\w${c_reset}\$(__git_prompt) :> "'
elif [ -n "$ZSH_VERSION" ]; then
    setopt PROMPT_SUBST
    PROMPT="%n@%m %{$c_path%}%~%{$c_reset%}\$(__git_prompt) :> "
    RPROMPT="${PYTHON_VIRTUALENV}"
else
    PROMPT="\n\w \$ "
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