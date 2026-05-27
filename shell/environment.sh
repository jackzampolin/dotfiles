# Guard against multiple sourcing
if [ -n "$ENVIRONMENT_LOADED" ]; then
    return
fi
ENVIRONMENT_LOADED=1

#
# Path Management
#
pathappend() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

pathprepend() {
    if [ -d "$1" ]; then
        PATH="${PATH//:$1:/:}"      # remove from middle
        PATH="${PATH/#$1:/}"        # remove from start
        PATH="${PATH/%:$1/}"        # remove from end
        PATH="$1${PATH:+":$PATH"}"
    fi
}

# Use the macOS launchd-managed SSH agent instead of spawning one per shell.
if command -v launchctl >/dev/null 2>&1; then
    launchd_ssh_sock="$(launchctl getenv SSH_AUTH_SOCK 2>/dev/null || true)"
    if [ -n "$launchd_ssh_sock" ] && [ -S "$launchd_ssh_sock" ]; then
        export SSH_AUTH_SOCK="$launchd_ssh_sock"
        unset SSH_AGENT_PID
    fi
    unset launchd_ssh_sock
fi

# Core paths
pathprepend "/opt/homebrew/sbin"
pathprepend "/opt/homebrew/bin"
pathappend "/usr/local/bin"
pathappend "/usr/local/sbin"

# Development tools
pathappend "/usr/local/go/bin"
pathappend "$HOME/.cargo/bin"
pathappend "$HOME/.orbstack/bin"
pathappend "$HOME/.local/bin"
pathappend "/usr/local/opt/coreutils/libexec/gnubin"

# Personal binaries and tools
pathappend "$HOME/bin"
pathappend "$HOME/.daml/bin"
pathappend "$HOME/.rvm/bin"
pathappend "/usr/local/heroku/bin"

export PATH

#
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
