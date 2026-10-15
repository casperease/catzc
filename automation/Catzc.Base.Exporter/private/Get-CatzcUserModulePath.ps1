<#
.SYNOPSIS
    Returns the current user's PowerShell 7 module folder — where Install-Catzc -Scope CurrentUser places Catzc.
.DESCRIPTION
    The same folder PowerShell itself puts first on a user's PSModulePath: <Documents>/PowerShell/Modules on Windows,...
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
