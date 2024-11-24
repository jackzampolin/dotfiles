#!/usr/bin/env sh
# bootstrap.sh - Setup dotfiles

set -eu

# Get dotfiles directory (POSIX compatible)
DOTS=$(cd "$(dirname "$0")" && pwd)

echo "Setting up dotfiles..."

# Create necessary directories
mkdir -p "$HOME/.venvs"
mkdir -p "$HOME/.nohup"

# Create secrets if it doesn't exist
if [ ! -f "$DOTS/shell/secrets.sh" ]; then
    cp "$DOTS/shell/secrets.template.sh" "$DOTS/shell/secrets.sh"
    echo "Created secrets.sh from template"
fi

# Link appropriate rc file based on shell
case "$(basename "$SHELL")" in
bash)
    ln -sf "$DOTS/bash_profile" "$HOME/.bash_profile"
    echo "Linked bash_profile"
    echo "Done! Please run: source ~/.bash_profile"
    ;;
zsh)
    ln -sf "$DOTS/zshrc" "$HOME/.zshrc"
    echo "Linked zshrc"
    echo "Done! Please run: source ~/.zshrc"
    ;;
*)
    echo "Unsupported shell: $SHELL"
    exit 1
    ;;
esac
