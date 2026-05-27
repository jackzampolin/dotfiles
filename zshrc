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

# zsh specific settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# zsh completions setup
fpath=("$dots/completions/zsh" $fpath)
autoload -U compinit && compinit

# Enable bash-style comments
setopt interactivecomments

# Enable advanced tab completion
zstyle ':completion:*' menu select

echo "Logged in as $USER at $(hostname). The time is $(date "+%H:%M"), good luck..."
