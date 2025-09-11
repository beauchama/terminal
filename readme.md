# Gear

A customized Windows terminal + PowerShell environment styled after
**Metal Gear Solid V: The Phantom Pain**.

Featuring:
- A dusty warzone color scheme
- Nerd font icons
- A custom [Oh My Posh] theme
- A custom [PowerShell 7] profile

## Requirements

Before setting up, ensure you have the following installed:

1. Install [Windows Terminal] from the Microsoft Store.
2. Download and install [JetBrainsMono Nerd Font]

## Install with winget

You can install the required software using `winget` commands:

```powershell
# Install PowerShell 7
winget install --id Microsoft.PowerShell -s winget

# Install Oh My Posh
winget install JanDeDobbeleer.OhMyPosh -s winget
```

## Setup

### Configure Windows Terminal

To set up the custom terminal profile 'Gear' and color scheme 'Phantom', follow these steps:

1. Open Windows Terminal.
2. Open the settings (Ctrl + ,).
3. Open the `settings.json` file.
4. Add the following color scheme to the `schemes`:
```json
{
    "name": "Phantom",
    "background": "#1B1B1B",
    "black": "#1B1B1B",
    "blue": "#6E7275",
    "brightBlack": "#3A3A3A",
    "brightBlue": "#9AA0A6",
    "brightCyan": "#B0BEC5",
    "brightGreen": "#FF8C42",
    "brightPurple": "#D2691E",
    "brightRed": "#FF3C28",
    "brightWhite": "#F5F5F5",
    "brightYellow": "#FFD27F",
    "cursorColor": "#FFFFFF",
    "cyan": "#8F9DA5",
    "foreground": "#C9A46C",
    "green": "#A35426",
    "purple": "#A35426",
    "red": "#B22222",
    "selectionBackground": "#FFFFFF",
    "white": "#E5E5E5",
    "yellow": "#C9A46C"
}
```
5. Add the following profile to the `profiles.list`:
```json
{
    "name": "Gear",
    "guid": "{bf06ed7b-0f31-4a96-af85-16024dc1c720}",
    "commandline": "pwsh.exe -NoLogo",
    "colorScheme": "Phantom",
    "adjustIndistinguishableColors": "always",
    "cursorColor": "#C9A46C",
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

## Configure Powershell 7

We will configure the Powershell 7 profile to use Oh My Posh and Phantom theme. Open the profile using the following command:

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

The profile includes the following modules which are required for Phantom theme to work properly

#### Posh Git

Posh Git is a PowerShell environment for Git. It provides Git status information and tab completion. You can find more information about Posh Git in their [repository][posh-git]

#### Terminal Icons

Terminal Icons is a PowerShell module that provides icons for files and folders. You can find more information about Terminal Icons in their [repository][terminal-icons]

#### PSReadLine

Module which need to be updated.

### Themes

The profile execute Oh My Posh with the custom theme Phantom by default.

### Optional scripts

The profile some optional scripts that you can use to customize your prompt. Is not required to use them.

#### .NET auto-completion

The script provides auto-completion for .NET commands. You can use it by typing `dotnet` and pressing `TAB`.

#### Winget auto-completion

The script provides auto-completion for winget commands. You can use it by typing `winget` and pressing `TAB`.

#### Github CLI auto-completion

The script provides auto-completion for gh commands. You can use it by typing `gh` and pressing `TAB`.

You need to install the respective software to use the auto-completion.

[Windows Terminal]: https://aka.ms/terminal
[PowerShell 7]: https://aka.ms/powershell
[JetBrainsMono Nerd Font]: https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
[Oh My Posh]: https://ohmyposh.dev/docs/installation
[posh-git]: https://github.com/dahlbyk/posh-git
[terminal-icons]: https://github.com/devblackops/Terminal-Icons
