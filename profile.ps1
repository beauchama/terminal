# Install required modules

if (!(Get-Module -ListAvailable posh-git))
{
    Install-Module posh-git -Scope CurrentUser -Force
}

if (!(Get-Module -ListAvailable Terminal-Icons))
{
    Install-Module Terminal-Icons -Scope CurrentUser -Force
}

if (!(Get-Module -ListAvailable PSReadline))
{
    Install-Module PSReadline -Scope CurrentUser -Force
}

# Load modules
Import-Module posh-git
Import-Module Terminal-Icons
Import-Module PSReadline

# Initialize oh-my-posh with custom themes

# You can choose one of the themes below by uncommenting the desired line
# oh-my-posh --init --shell pwsh --config https://cdn.jsdelivr.net/gh/beauchama/terminal@main/themes/phantom.omp.json | Invoke-Expression
# oh-my-posh --init --shell pwsh --config https://cdn.jsdelivr.net/gh/beauchama/terminal@main/themes/kirby.omp.json | Invoke-Expression
# oh-my-posh --init --shell pwsh --config https://cdn.jsdelivr.net/gh/beauchama/terminal@main/themes/twilight.omp.json | Invoke-Expression
# oh-my-posh --init --shell pwsh --config https://cdn.jsdelivr.net/gh/beauchama/terminal@main/themes/totk.omp.json | Invoke-Expression
oh-my-posh --init --shell pwsh --config https://cdn.jsdelivr.net/gh/beauchama/terminal@main/themes/zelda.omp.json | Invoke-Expression

# PowerShell parameter completion for dotnet
# https://docs.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
        dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
           [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

# PowerShell parameter completion for winget
# https://github.com/microsoft/winget-cli/blob/master/doc/Completion.md
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

# Generate completion for gh
# https://cli.github.com/manual/gh_completion
Invoke-Expression -Command $(gh completion -s powershell | Out-String)
