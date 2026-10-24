#!/usr/bin/env bash
# Sets up zsh, Oh My Posh, the Nerd Font and the Ptyxis palettes on Ubuntu.
# Usage: ./install.sh [opacity]   (opacity of the Ptyxis profiles, 0 to 1, default 0.85)
set -euo pipefail

linux_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
opacity="${1:-0.85}"

sudo apt-get install -y zsh zsh-autosuggestions zsh-syntax-highlighting eza unzip curl

# Oh My Posh and the font
mkdir -p "$HOME/.local/bin"
if ! command -v oh-my-posh > /dev/null && [[ ! -x "$HOME/.local/bin/oh-my-posh" ]]; then
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin"
fi
omp="$(command -v oh-my-posh || echo "$HOME/.local/bin/oh-my-posh")"
"$omp" font install JetBrainsMono

# Ptyxis palettes
palette_dir="$HOME/.local/share/org.gnome.Ptyxis/palettes"
mkdir -p "$palette_dir"
cp "$linux_dir"/palettes/*.palette "$palette_dir/"

# Ptyxis opacity (no slider in the preferences); profiles exist once Ptyxis has run
if gsettings list-schemas | grep -qx org.gnome.Ptyxis; then
    for uuid in $(gsettings get org.gnome.Ptyxis profile-uuids | tr -d "[],'"); do
        gsettings set "org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$uuid/" opacity "$opacity"
    done
fi

# zsh profile, linked so a git pull updates it
if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi
ln -sf "$linux_dir/zshrc" "$HOME/.zshrc"

if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]]; then
    chsh -s "$(command -v zsh)"
fi

echo "Done. Log out and back in, then pick a palette and JetBrainsMono Nerd Font in the Ptyxis preferences."
