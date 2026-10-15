<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/Get-InstallScope.ps1
    kind: function
    module: Catzc.Tooling.Core
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the install scope of a tool based on its binary location.
.DESCRIPTION
    Only the path decides, never the privileges used to install; unknown means no platform branch matched.
    [comment:1](/docs/references/automation/catzc-tooling-core/Get-InstallScope.ps1.md#comment1)
.PARAMETER Config
    Tool configuration hashtable from Get-ToolConfig / tools.yml.
.PARAMETER Location
    Full path to the tool binary (from Get-Command .Source).
#>
function Get-InstallScope {
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Config,
        [Parameter(Mandatory)]
        [string] $Location
    )

    # Script-installed tools (e.g., Dotnet via dotnet-install scripts).
    if ($Config.script_install) {
        $userDir = Get-ScriptInstallDir -Config $Config
        if ($Location -like "$userDir*") {
            return 'user'
        }
        return 'machine'
    }

    if ($IsWindows) {
        # User-space installs go under LOCALAPPDATA, APPDATA, or USERPROFILE
        foreach ($root in @($env:LOCALAPPDATA, $env:APPDATA, $env:USERPROFILE) | Where-Object { $_ }) {
            if ($Location -like "$root*") {
                return 'user'
            }
        }
        return 'machine'
    }

    if ($IsMacOS) {
        # brew installs to /opt/homebrew/ or /usr/local/ — user-space
        return 'user'
    }

    if ($IsLinux) {
        # pip --user and user-local tools live under ~/.local/
        $homeLocal = Join-Path $HOME '.local'
        if ($Location -like "$homeLocal*") {
            return 'user'
        }
        # apt-get, system pip, etc. → machine
        return 'machine'
    }

    'unknown'
}
