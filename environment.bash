# #!/bin/bash

# Color the git prompt (https://wiki.archlinux.org/index.php/Color_Bash_Prompt)
c_reset='\[\e[0m\]'
c_path='\[\e[0;31m\]'
c_git_clean='\[\e[0;32m\]'
c_git_dirty='\[\e[0;31m\]'
BLUE="\[\033[1;34m\]"
COLOR_NONE="\[\e[0m\]"

# # If venv is activated set $PYTHON_VIRTUALENV
__set_virtualenv

# # PROMPT_COMMAND runs first, then PS1 (http://blog.superuser.com/2011/09/21/customizing-your-bash-command-prompt/)
# # TODO: Possibly figure out exactly how this works. Could be a fun project
export PROMPT_COMMAND='PS1="${c_path}\W${c_reset}$(__git_prompt) :> "'
export PS1='\n\[\033[0;31m\]\W\[\033[0m\]$(__git_prompt)\[\033[0m\]:> '

# File type colors (http://geoff.greer.fm/lscolors/)
export LSCOLORS=ExGxFxdxCxDxDxaccxaeex

# Set $GOPATH (https://github.com/golang/go/wiki/GOPATH)
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export GITHUB=$GOPATH/src/github.com

# Add [ $GOBIN, $HOME/bin, /usr/local/bin, /usr/local/sbin, /usr/local/heroku/bin, $HOME/.rvm/bin, $HOME/bin, /usr/local/go/bin ] to path
export PATH=$PATH:$GOBIN:$HOME/.rvm/bin:/usr/local/go/bin:/usr/local/bin:/usr/local/sbin:/usr/local/opt/coreutils/libexec/gnubin:/usr/local/heroku/bin:$HOME/.cargo/bin:$HOME/bin:$HOME/.daml/bin

# Enable GPG signing in git
GPG_TTY=$(tty)
export GPG_TTY

# Use go mod by default, remove once this is standard behavior in golang
export GO111MODULE=on
export CLOUDSDK_PYTHON=$(which python)
