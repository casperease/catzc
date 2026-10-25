<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-core/Get-ScriptInstallDir.ps1.md"
  warning: "Generated Header"
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
