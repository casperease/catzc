<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Get-ScriptInstallDir.ps1
    kind: public-function
    module: Catzc.Tooling.Core
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Resolves the install directory for a script-installed tool, or the Windows tree an MSYS2 package installs into.
.DESCRIPTION
    Config overrides win, else Windows uses LOCALAPPDATA and Unix a dot-directory under HOME, named after the command.
.PARAMETER Config
    Tool configuration hashtable from Get-ToolConfig / tools.yml.
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
