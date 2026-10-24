#!/usr/bin/env bash
# Sets up kitty, zsh, Oh My Posh and the Nerd Font on Ubuntu.
set -euo pipefail

linux_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo apt-get install -y kitty zsh zsh-autosuggestions eza unzip curl

# Oh My Posh and the font
mkdir -p "$HOME/.local/bin"
if ! command -v oh-my-posh > /dev/null && [[ ! -x "$HOME/.local/bin/oh-my-posh" ]]; then
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin"
fi
omp="$(command -v oh-my-posh || echo "$HOME/.local/bin/oh-my-posh")"
"$omp" font install JetBrainsMono

# Links, so a git pull updates them; existing files are kept as *.backup
link() {
    local source="$1" target="$2"
    if [[ -e "$target" && ! -L "$target" ]]; then
        mv "$target" "$target.backup"
    fi
    ln -sfn "$source" "$target"
}

mkdir -p "$HOME/.config"
link "$linux_dir/kitty" "$HOME/.config/kitty"
link "$linux_dir/zshrc" "$HOME/.zshrc"

if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]]; then
    chsh -s "$(command -v zsh)"
fi

echo "Done. Log out and back in, then open kitty."
