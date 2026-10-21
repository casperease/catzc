<#
---
catzc:
  immutable:
    with_body_sha: "7a0963351fdd"
  edges:
    docs: "[Get-InstallScope.ps1.md](docs/references/pwsh/catzc-tooling-core/Get-InstallScope.ps1.md)"
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
