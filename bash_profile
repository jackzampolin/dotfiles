# Define dotfiles location
dots="$HOME/.dotfiles"

# Load common shell files
for file in "$dots/config"/*.sh; do
    [ -r "$file" ] && . "$file"
done

# Load programs
for file in "$dots/programs"/*.sh; do
    [ -r "$file" ] && . "$file"
done

# Shell-specific completions
if [ -n "$BASH_VERSION" ]; then
    for file in "$dots/completions/bash"/*; do
        [ -r "$file" ] && . "$file"
    done
elif [ -n "$ZSH_VERSION" ]; then
    for file in "$dots/completions/zsh"/*; do
        [ -r "$file" ] && . "$file"
    done
fi

echo "Logged in as $USER at $(hostname). The time is $(date "+%H:%M"), good luck..."