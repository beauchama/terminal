# Terminal

Customize Windows Terminal settings, appearance and enhance PowerShell experience, with the same look on Linux (zsh with Ptyxis or Konsole).

## Features

- Multiple themes
- Use nerd fonts icons in terminal
- Autocompletion for PowerShell
- Enhanced prompt with Git status
- Linux setup for Fedora and Ubuntu with the same themes

## Requirements

Before setting up the terminal, make sure you have the following prerequisites installed:

- Install [Windows Terminal] from the Microsoft Store.
- Download and install [JetBrainsMono Nerd Font]
- [Oh My Posh] for PowerShell prompt theming.
- PowerShell 7 or higher.

### Installation

You can install Oh My Posh and PowerShell 7 by running the following command in the terminal:

```powershell
winget install --id Microsoft.PowerShell
winget install JanDeDobbeleer.OhMyPosh
```

## Setup

### Configure Windows Terminal

To apply the custom settings for Windows Terminal, follow these steps:

1. Open Windows Terminal.
2. Click on the dropdown arrow next to the tabs and select "Settings".
3. Open the `settings.json` file by clicking on "Open JSON file".
4. Add the provided configuration to your `settings.json` file. Make sure to adjust any paths or settings as needed.

Add the following profile configuration to the `profiles.list`:
```json
{
    "name": "Terminal",
    "guid": "{bf06ed7b-0f31-4a96-af85-16024dc1c720}",
    "commandline": "pwsh.exe -NoLogo",
    "colorScheme": "zelda", // You can change to any color scheme, see themes/readme.md
    "adjustIndistinguishableColors": "always",
    "cursorShape": "vintage",
    "font":
    {
        "face": "JetBrainsMono NF",
        "size": 14
    },
    "hidden": false,
    "opacity": 85,
    "startingDirectory": "Path which you want to start",
    "suppressApplicationTitle": true
}
```
> See [Windows Terminal documentation](https://docs.microsoft.com/en-us/windows/terminal/customize-settings/profile-settings) for more details.

### Configure PowerShell

To enhance your PowerShell experience with Oh My Posh and autocompletion, follow these steps:

:warning: Make sure to open a powershell 7 terminal. :warning:

```pwsh
code $PROFILE
```

It will open the profile in Visual Studio Code. Copy [profile.ps1](./profile.ps1) provided in this repository and paste it in the profile. Save the file and reload the prompt using the following command:

```pwsh
. $PROFILE
```

You can read more about [profile.ps1](#profileps1) in the section below.

## Profile.ps1

The profile.ps1 is a script that runs every time you open powershell. The profile provided in this repository is configured to include Oh My Posh and Phantom theme. You can customize the profile to include more modules or themes.

### Modules

The profile includes the following modules which are required to work properly.

#### Posh Git

Posh Git is a PowerShell environment for Git. It provides Git status information and tab completion. You can find more information about Posh Git in their [repository][posh-git]

#### Terminal Icons

Terminal Icons is a PowerShell module that provides icons for files and folders. You can find more information about Terminal Icons in their [repository][terminal-icons]

#### PSReadLine

Module which need to be updated.

### Themes

The profile execute Oh My Posh with a custom theme. You can change the theme by modifying the `profile.ps1` file then uncommenting the desired theme line.

### Optional scripts

The profile includes some optional scripts that you can use to customize your prompt. It is not required to use them.

#### .NET auto-completion

The script provides auto-completion for .NET commands. You can use it by typing `dotnet` and pressing `TAB`.

#### Winget auto-completion

The script provides auto-completion for winget commands. You can use it by typing `winget` and pressing `TAB`.

#### Github CLI auto-completion

The script provides auto-completion for gh commands. You can use it by typing `gh` and pressing `TAB`.

You need to install the respective software to use the auto-completion.

## Linux (Fedora and Ubuntu)

The same Oh My Posh themes work on Linux. zsh takes the place of PowerShell, and the desktop's terminal the place of Windows Terminal: Konsole with KDE Plasma (Fedora KDE, Kubuntu), Ptyxis with GNOME (Fedora Workstation, Ubuntu). The script installs the packages with `dnf` or `apt`.

| Windows                       | Linux                                                    |
| ----------------------------- | -------------------------------------------------------- |
| Windows Terminal color scheme | Ptyxis palette in [linux/palettes](./linux/palettes), Konsole color scheme in [linux/konsole](./linux/konsole) |
| PowerShell 7 and PSReadLine   | zsh with zsh-autosuggestions and zsh-syntax-highlighting |
| posh-git                      | zsh's Git completion and the Oh My Posh `git` segment    |
| Terminal-Icons                | `eza --icons`                                            |
| `profile.ps1`                 | [linux/zshrc](./linux/zshrc)                             |

### Install

Clone the repository, then run the script. It installs the packages, Oh My Posh and JetBrainsMono Nerd Font, sets up the colors of whichever terminal is installed (Ptyxis or Konsole), creates a `~/.zshrc` that sources `linux/zshrc` (an existing one is kept as `~/.zshrc.backup`) and makes zsh your shell.

```bash
bash linux/install.sh        # optional argument: terminal opacity, 0 to 1 (default 0.85)
```

With GNOME, open Ptyxis once before running it, so its profile exists for the opacity. Log out and back in afterwards.

### .NET

[dotnetup](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnetup/getting-started) manages the SDKs and the environment (`DOTNET_ROOT`, `PATH`); [linux/zshrc](./linux/zshrc) sets no .NET path. Run the install script first, then:

```bash
curl -fsSL https://aka.ms/dotnetup/get-dotnetup.sh | bash
dotnetup init --shell zsh    # keep the "shell" access mode
```

dotnetup writes its lines in `~/.zshrc`, below the line that sources the repository, so the repository stays untouched. The `dotnet` completion loads at the first prompt, after those lines.

### Configure Ptyxis

1. Open the preferences and edit the profile: pick one of the palettes (Kirby, Phantom, Zelda, Twilight, TOTK) and an underline cursor.
2. In the appearance settings, turn off the system font and pick **JetBrainsMono Nerd Font**, size 12.

Ptyxis has no opacity slider. The script sets it on every profile; to change it later:

```bash
for uuid in $(gsettings get org.gnome.Ptyxis profile-uuids | tr -d "[],'"); do
    gsettings set "org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$uuid/" opacity 0.85
done
```

### Configure Konsole

Nothing to do: the script creates a **Terminal** profile, makes it the default, and gives it the color scheme of the theme selected in [linux/zshrc](./linux/zshrc), JetBrainsMono Nerd Font size 12, an underline cursor and the opacity with blur.

To switch theme later, uncomment another `theme=` line in [linux/zshrc](./linux/zshrc) and run the script again, or pick the color scheme in *Settings → Edit Current Profile → Appearance*. The opacity is in the color scheme's *Edit…* dialog.

### Themes

Change the theme by uncommenting the desired `theme=` line in [linux/zshrc](./linux/zshrc), then pick the matching palette in Ptyxis (Konsole: see above).

[Windows Terminal]: https://aka.ms/terminal
[PowerShell 7]: https://aka.ms/powershell
[JetBrainsMono Nerd Font]: https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
[Oh My Posh]: https://ohmyposh.dev/docs/installation
[posh-git]: https://github.com/dahlbyk/posh-git
[terminal-icons]: https://github.com/devblackops/Terminal-Icons
