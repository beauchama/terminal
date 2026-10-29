#!/usr/bin/env bash
# Sets up zsh, Oh My Posh, the Nerd Font and the terminal colors on Fedora or Ubuntu,
# with Konsole (KDE Plasma) or Ptyxis (GNOME).
# Usage: ./install.sh [opacity]   (terminal opacity, 0 to 1, default 0.85)
set -euo pipefail

linux_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
opacity="${1:-0.85}"

# Packages: dnf (Fedora) or apt (Ubuntu); eza is optional, ls falls back to plain output
packages=(zsh zsh-autosuggestions zsh-syntax-highlighting unzip curl)
if command -v dnf > /dev/null; then
    sudo dnf install -y "${packages[@]}" util-linux-user   # util-linux-user provides chsh
    sudo dnf install -y eza || echo "eza is not available, ls keeps its plain output."
elif command -v apt-get > /dev/null; then
    sudo apt-get install -y "${packages[@]}"
    sudo apt-get install -y eza || echo "eza is not available, ls keeps its plain output."
else
    echo "Unsupported distribution: install ${packages[*]} yourself, then run this script again." >&2
    exit 1
fi

# Oh My Posh and the font
mkdir -p "$HOME/.local/bin"
if ! command -v oh-my-posh > /dev/null && [[ ! -x "$HOME/.local/bin/oh-my-posh" ]]; then
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin"
fi
omp="$(command -v oh-my-posh || echo "$HOME/.local/bin/oh-my-posh")"
"$omp" font install JetBrainsMono

# Ptyxis palettes and opacity (GNOME); profiles exist once Ptyxis has run
if command -v ptyxis > /dev/null; then
    palette_dir="$HOME/.local/share/org.gnome.Ptyxis/palettes"
    mkdir -p "$palette_dir"
    cp "$linux_dir"/palettes/*.palette "$palette_dir/"

    if gsettings list-schemas | grep -qx org.gnome.Ptyxis; then
        for uuid in $(gsettings get org.gnome.Ptyxis profile-uuids | tr -d "[],'"); do
            gsettings set "org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$uuid/" opacity "$opacity"
        done
    fi
fi

# Konsole color schemes and a default profile (KDE)
if command -v konsole > /dev/null; then
    konsole_dir="$HOME/.local/share/konsole"
    mkdir -p "$konsole_dir"
    for scheme in "$linux_dir"/konsole/*.colorscheme; do
        sed "s/^Opacity=.*/Opacity=$opacity/" "$scheme" > "$konsole_dir/$(basename "$scheme")"
    done

    # The profile follows the theme selected in zshrc, cursor color included
    theme="$(sed -n 's/^theme=//p' "$linux_dir/zshrc")"
    cursor="$(sed -n 's/^Cursor=#//p' "$linux_dir/palettes/$theme.palette")"
    cursor_rgb="$((16#${cursor:0:2})),$((16#${cursor:2:2})),$((16#${cursor:4:2}))"

    cat > "$konsole_dir/Terminal.profile" << EOF
[Appearance]
ColorScheme=$theme
Font=JetBrainsMono Nerd Font,12

[Cursor Options]
CursorShape=2
CustomCursorColor=$cursor_rgb
UseCustomCursorColor=true

[General]
Command=$(command -v zsh)
Name=Terminal
Parent=FALLBACK/
EOF

    if command -v kwriteconfig6 > /dev/null; then
        kwriteconfig6 --file konsolerc --group "Desktop Entry" --key DefaultProfile Terminal.profile
    fi
fi

# zsh profile: ~/.zshrc sources the repository's zshrc, so a git pull updates it,
# and stays a real file where tools such as dotnetup can add their own lines
zshrc_line="source \"$linux_dir/zshrc\""
if [[ -L "$HOME/.zshrc" ]]; then
    rm "$HOME/.zshrc"
elif [[ -f "$HOME/.zshrc" ]] && ! grep -qxF "$zshrc_line" "$HOME/.zshrc"; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi
if [[ ! -f "$HOME/.zshrc" ]]; then
    printf '%s\n' "# Shared settings live in the terminal repository; tools may append below." "$zshrc_line" > "$HOME/.zshrc"
fi

if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v zsh)" ]]; then
    chsh -s "$(command -v zsh)"
fi

echo "Done. Log out and back in."
if command -v ptyxis > /dev/null; then
    echo "In the Ptyxis preferences, pick a palette and JetBrainsMono Nerd Font."
fi
