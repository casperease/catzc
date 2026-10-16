<#
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Core/Get-InstallScope.ps1
    name: get-install-scope
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  config:
    synopsis: Returns the install scope of a tool based on its binary location.
    description: |-
      Determines whether a tool is installed in user-space or machine-wide
      by inspecting the binary path. Returns 'user', 'machine', or 'unknown'.
    parameters:
      Config: Tool configuration hashtable from Get-ToolConfig / tools.yml.
      Location: Full path to the tool binary (from Get-Command .Source).
---
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
