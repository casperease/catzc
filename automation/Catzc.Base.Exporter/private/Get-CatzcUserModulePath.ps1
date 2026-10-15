# catzc:
#   path: automation/Catzc.Base.Exporter/private/Get-CatzcUserModulePath.ps1
#   module: Catzc.Base.Exporter
#   visibility: private

<#
.SYNOPSIS
    Returns the current user's PowerShell 7 module folder — where Install-Catzc -Scope CurrentUser places Catzc.
.DESCRIPTION
    It matches the first user entry of PSModulePath, so Import-Module Catzc finds the install from any shell.
    [comment:1](/docs/references/automation/catzc-base-exporter/private/Get-CatzcUserModulePath.ps1.md#comment1)
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
