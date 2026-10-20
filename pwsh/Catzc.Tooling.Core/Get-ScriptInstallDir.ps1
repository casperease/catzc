<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Core/Get-ScriptInstallDir.ps1
    name: get-script-install-dir
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    docs: "[Get-ScriptInstallDir.ps1.md](docs/references/pwsh/catzc-tooling-core/Get-ScriptInstallDir.ps1.md)"
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
