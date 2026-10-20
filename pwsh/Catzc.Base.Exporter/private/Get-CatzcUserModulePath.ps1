<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Exporter/private/Get-CatzcUserModulePath.ps1
    folder: private
    name: get-catzc-user-module-path
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Exporter
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Get-CatzcUserModulePath.ps1.md](docs/references/pwsh/catzc-base-exporter/private/Get-CatzcUserModulePath.ps1.md)"
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
