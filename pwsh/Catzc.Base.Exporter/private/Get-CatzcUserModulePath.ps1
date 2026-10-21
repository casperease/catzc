<#
---
catzc:
  immutable:
    with_body_sha: "45cd3d2f3dde"
  edges:
    docs: "[Get-CatzcUserModulePath.ps1.md](../../../docs/references/pwsh/catzc-base-exporter/private/Get-CatzcUserModulePath.ps1.md)"
---
#>

function Get-CatzcUserModulePath {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if ($IsWindows) {
        return Join-Path ([System.Environment]::GetFolderPath('MyDocuments')) 'PowerShell/Modules'
    }
    Join-Path ([System.Environment]::GetFolderPath('LocalApplicationData')) 'powershell/Modules'
}
