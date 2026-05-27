# Define dotfiles location
dots="$HOME/.dotfiles"

# Load environment first so later files can safely use exported vars.
[ -r "$dots/shell/environment.sh" ] && . "$dots/shell/environment.sh"

# Load remaining common shell files
for file in "$dots/shell"/*.sh; do
  [ "$file" = "$dots/shell/environment.sh" ] && continue
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
