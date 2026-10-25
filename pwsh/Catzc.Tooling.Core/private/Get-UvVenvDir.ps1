<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-tooling-core/private/Get-UvVenvDir.ps1.md"
  warning: "Generated Header"
---
#>

function Get-UvVenvDir {
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Tool
    )

    $root = if ($IsWindows) {
        Join-Path $env:LOCALAPPDATA 'catzc\venvs'
    }
    else {
        Join-Path $HOME '.local/share/catzc/venvs'
    }
    Join-Path $root $Tool
}
