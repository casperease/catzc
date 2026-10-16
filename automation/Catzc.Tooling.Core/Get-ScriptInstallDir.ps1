<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Get-ScriptInstallDir.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
  config:
    synopsis: Resolves the install directory for a script-installed tool, or the Windows tree an MSYS2 package installs into.
    description: |-
      Returns the platform-appropriate install directory for a tool with script_install: true, and for a tool with an
      msys2_url, whose Windows tree is the one its windows_install_dir names (zsh installs into Install-Git's Git for
      Windows tree). Checks config overrides first, then falls back to sensible defaults per platform:
        Windows: LOCALAPPDATA\<windows_install_dir or command>
        Unix:    HOME/<unix_install_dir or .command>
    parameters:
      Config: Tool configuration hashtable from Get-ToolConfig / tools.yml.
---
#>

function Get-ScriptInstallDir {
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    if ($IsWindows) {
        $relative = $Config.windows_install_dir ?? $Config.command
        return Join-Path $env:LOCALAPPDATA $relative
    }

    $relative = $Config.unix_install_dir ?? ".$($Config.command)"
    Join-Path $HOME $relative
}
