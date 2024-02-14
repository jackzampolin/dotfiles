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