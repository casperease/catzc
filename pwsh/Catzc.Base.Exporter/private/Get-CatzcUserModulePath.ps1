<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-exporter/private/Get-CatzcUserModulePath.ps1.md"
  header: "generated"
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
