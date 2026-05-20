<#
.SYNOPSIS
    Resolves the install directory for a script-installed tool.
.DESCRIPTION
    Returns the platform-appropriate install directory for tools with
    ScriptInstall: true. Checks config overrides first, then falls back
    to sensible defaults per platform:
      Windows: LOCALAPPDATA\<windows_install_dir or command>
      Unix:    HOME/<unix_install_dir or .command>
.PARAMETER Config
    Tool configuration hashtable from Get-ToolConfig / tools.yml.
#>
function Get-ScriptInstallDir {
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Config
    )

    if ($IsWindows) {
        $relative = $Config.windows_install_dir ?? $Config.command
        return Join-Path $env:LOCALAPPDATA $relative
    }

    $relative = $Config.unix_install_dir ?? ".$($Config.command)"
    Join-Path $HOME $relative
}
