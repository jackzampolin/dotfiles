#!/bin/bash

#
# File System Navigation
#
# List files after changing directories
cd() {
    builtin cd "$@" && ls -AFCG
}

# Make and change into directory
mcd() {
    if [ -z "$1" ]; then
        echo "Usage: mcd <directory>"
        return 1
    fi
    mkdir -pv "$1" && cd "$1"
}

#
# Archive Management
#
# Extract various archive formats
extract() {
    if [ ! -f "$1" ]; then
        echo "'$1' is not a valid file!"
        return 1
    fi

    case "$1" in
        *.tar.bz2) tar xvjf "$1" ;;
        *.tar.gz)  tar xvzf "$1" ;;
        *.bz2)     bunzip2 "$1"  ;;
        *.rar)     unrar x "$1"  ;;
        *.gz)      gunzip "$1"   ;;
        *.tar)     tar xvf "$1"  ;;
        *.tbz2)    tar xvjf "$1" ;;
        *.tgz)     tar xvzf "$1" ;;
        *.zip)     unzip "$1"    ;;
        *.Z)       uncompress "$1" ;;
        *.7z)      7z x "$1"     ;;
        *)         echo "'$1' cannot be extracted via extract()" ;;
    esac
}

#
# Development Tools
#
# Generate random string
rand() {
    if [ -z "$1" ]; then
        echo "Usage: rand <length>"
        return 1
    fi
    LC_ALL=C tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w "$1" | head -n 1
}

# Pretty print clipboard JSON
jcat() {
    pbpaste | jq
}

# Remove entry from SSH known_hosts
rmk() {
    if [ -z "$1" ]; then
        echo "Usage: rmk <host>"
        return 1
    fi
    ssh-keygen -R "$1"
}

#
# Docker Tools
#
docker_clock() {
    echo "Syncing docker clock with local clock..."
    docker run --rm --privileged alpine hwclock -s
}

#
# Media Tools
#
makegif() {
    if [ -z "$1" ]; then
        echo "Usage: makegif <input.mp4>"
        return 1
    fi
    ffmpeg -i "$1" -s 600x400 -pix_fmt rgb8 -r 10 -f gif - | \
    gifsicle --optimize=0 --delay=10 > "$(basename "$1" .mp4).gif"
}

#
# Dotfiles Management
#
sync() {
    local -a files=(
        "bash_profile"
        "zshrc"
        "gitconfig"
    )

    for file in "${files[@]}"; do
        local src="$HOME/.dotfiles/$file"
        local dst="$HOME/.$file"

        if [ -f "$src" ]; then
            echo "Overwriting $dst with $src"
            cp "$src" "$dst"
        else
            echo "Source file '$src' does not exist, skipping..."
        fi
    done

    if [ -f "$HOME/.bash_profile" ]; then
        source "$HOME/.bash_profile"
    elif [ -f "$HOME/.zshrc" ]; then
        source "$HOME/.zshrc"
    else
        echo "No shell profile found to source."
    fi
}

#
# Blockchain Tools
#
wenupgrade() {
    local cheight=$(curl -s https://api.cosmostation.io/v1/status | jq -r '.block_height')
    local uheight=6910000
    local blktime=7.5
    local secs=$(bc <<< "scale=0; (($uheight - $cheight) * $blktime)/1")
    printf "Hub upgrade in %dh %dm\n" $((secs / (60 * 60))) $(((secs % (60*60))/60))
}
