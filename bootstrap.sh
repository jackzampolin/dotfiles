#!/usr/bin/env sh
# bootstrap.sh - Setup dotfiles

set -eu

# Get dotfiles directory (POSIX compatible)
DOTS=$(cd "$(dirname "$0")" && pwd)

echo "Setting up dotfiles..."

# Create necessary directories
mkdir -p "$HOME/.venvs"
mkdir -p "$HOME/.nohup"
mkdir -p "$HOME/.cargo"

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

# Install and enable the shared Rust compiler cache on Homebrew-managed hosts.
# Do not link a Cargo wrapper that cannot be executed.
find_sccache() {
    if command -v sccache >/dev/null 2>&1; then
        command -v sccache
        return
    fi
    for candidate in /opt/homebrew/bin/sccache /usr/local/bin/sccache "$HOME/.cargo/bin/sccache"; do
        if [ -x "$candidate" ]; then
            printf '%s\n' "$candidate"
            return
        fi
    done
    return 1
}

SCCACHE_BIN=$(find_sccache || true)
if [ -z "$SCCACHE_BIN" ]; then
    BREW=""
    if command -v brew >/dev/null 2>&1; then
        BREW=$(command -v brew)
    elif [ -x /opt/homebrew/bin/brew ]; then
        BREW=/opt/homebrew/bin/brew
    elif [ -x /usr/local/bin/brew ]; then
        BREW=/usr/local/bin/brew
    fi
    if [ -n "$BREW" ]; then
        HOMEBREW_NO_AUTO_UPDATE=1 "$BREW" install sccache
        SCCACHE_BIN=$(find_sccache || true)
    fi
fi

if [ -n "$SCCACHE_BIN" ]; then
    if [ -f "$HOME/.cargo/config.toml" ] && [ ! -L "$HOME/.cargo/config.toml" ]; then
        backup="$HOME/.cargo/config.toml.pre-dotfiles"
        suffix=0
        while [ -e "$backup" ]; do
            suffix=$((suffix + 1))
            backup="$HOME/.cargo/config.toml.pre-dotfiles.$suffix"
        done
        cp -p "$HOME/.cargo/config.toml" "$backup"
        echo "Backed up existing Cargo config to $backup"
    fi
    ln -sf "$DOTS/cargo/config.toml" "$HOME/.cargo/config.toml"
    echo "Linked Cargo config with sccache wrapper"
else
    echo "sccache is unavailable; left Cargo config unchanged"
fi
