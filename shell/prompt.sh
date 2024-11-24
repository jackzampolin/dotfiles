#!/bin/bash

# Handle different shells
if [ -n "$ZSH_VERSION" ]; then
    # ZSH colors
    c_reset="%f"
    c_path="%F{red}"
    c_git_clean="%F{green}"
    c_git_dirty="%F{red}"
    BLUE="%F{blue}"
    COLOR_NONE="%f"
else
    # Bash colors
    c_reset='\[\e[0m\]'
    c_path='\[\e[0;31m\]'
    c_git_clean='\[\e[0;32m\]'
    c_git_dirty='\[\e[0;31m\]'
    BLUE="\[\033[1;34m\]"
    COLOR_NONE="\[\e[0m\]"
fi

# Virtualenv prompt
__set_virtualenv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        if [ -n "$ZSH_VERSION" ]; then
            PYTHON_VIRTUALENV="${BLUE}[$(basename "$VIRTUAL_ENV")]${COLOR_NONE} "
        else
            PYTHON_VIRTUALENV="${BLUE}[$(basename "$VIRTUAL_ENV")]${COLOR_NONE} "
        fi
    else
        PYTHON_VIRTUALENV=""
    fi
}

# Git prompt
__git_prompt() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        return 0
    fi
    git_branch=$(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')
    if [ -n "$ZSH_VERSION" ]; then
        if git diff --quiet 2>/dev/null >&2; then
            echo " [${c_git_clean}${git_branch}${c_reset}]"
        else
            echo " [${c_git_dirty}${git_branch}${c_reset}]"
        fi
    else
        if git diff --quiet 2>/dev/null >&2; then
            echo " [${c_git_clean}${git_branch}${c_reset}]"
        else
            echo " [${c_git_dirty}${git_branch}${c_reset}]"
        fi
    fi
}

# Set prompt based on shell
if [ -n "$ZSH_VERSION" ]; then
    PROMPT=$'%{\n%}${c_path}%1~${c_reset}$(__git_prompt) :> '
    # PROMPT=$'\n${c_path}%1~${c_reset}$(__git_prompt) :> '
else
    PS1='\n\[\033[0;31m\]\W\[\033[0m\]$(__git_prompt)\[\033[0m\]:> '
fi
