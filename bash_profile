# Define dotfiles location
dots="$HOME/.dotfiles"

# Load common shell files
for file in "$dots/shell"/*.sh; do
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
fi

