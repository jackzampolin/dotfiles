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
# Organization directories
declare -A gh_dirs=(
   ["i"]="iqlusioninc"
   ["j"]="jackzampolin"
   ["c"]="cosmos"
   ["a"]="althea-net"
   ["o"]="ovrclk"
   ["r"]="rollchains"
   ["p"]="peggyjv"
   ["t"]="tendermint"
   ["bi"]="blockstackinc"
   ["s"]="strangelove-ventures"
)

# Create cd aliases for each directory
for key in "${!gh_dirs[@]}"; do
   alias "cd${key}"="cd $GITHUB/${gh_dirs[$key]}"
done
alias cdgh="cd $GITHUB/"

#
# Common Shortcuts
#
# Basic commands
alias e='code'                  # Editor
alias r='source ~/.bash_profile' # Reload shell
alias c='clear'                 # Clear screen
alias ls='ls -AFCG'            # Enhanced ls
alias tf='terraform'           # Terraform
alias weather='curl wttr.in'   # Weather info
alias hgrep='history | grep'   # Search history

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