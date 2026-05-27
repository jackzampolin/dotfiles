#!/bin/bash

#
# Platform-Specific Configuration
#
case "$(uname)" in
'Linux')
   alias pbcopy="xclip -selection clipboard"
   alias pbpaste="xclip -selection clipboard -o"
   alias f='xdg-open'
   ;;
'Darwin')
   alias f='open -a Finder'
   ;;
esac

#
# GitHub Navigation
#

#
# GitHub Navigation
#

# Create individual cd aliases for each directory
alias cdj='cd $GITHUB/jackzampolin'
alias cds='cd $GITHUB/sourcenetwork'
alias cdsi='cd $GITHUB/source'
alias cdsl='cd $GITHUB/strangelove-ventures'
alias cdgh='cd $GITHUB/'

#
# Common Shortcuts
#
# Basic commands
alias e='code'               # Editor
alias c='clear'              # Clear screen
alias ls='ls -AFCG'          # Enhanced ls
alias tf='terraform'         # Terraform
alias weather='curl wttr.in' # Weather info
alias hgrep='history | grep' # Search history

# Shell reload
if [ -n "$ZSH_VERSION" ]; then
   alias r='source ~/.zshrc'
else
   alias r='source ~/.bash_profile'
fi

#
# Clipboard Operations
#
# Copy operations
alias pubKey='cat ~/.ssh/id_rsa.pub | pbcopy'
alias shrug='echo "¯\_(ツ)_/¯" | pbcopy'
alias gitsha='git rev-parse --short HEAD | pbcopy'
alias path='pwd | pbcopy'

# Text processing
alias freq="pbpaste | tr ' ' '\n' | sort | uniq -c | sort"

#
# Development Tools
#
# Docker cleanup
alias dc='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

# Database
alias influx='influx -precision rfc3339'
