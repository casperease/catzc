<#
.SYNOPSIS
    Universal pipeline entry point. Bootstraps the module system and executes a command.
.DESCRIPTION
    Called by the invoke-automation.yaml step template.
    [comment:1](/docs/references/pipelines/Invoke-AdoScript.ps1.md#comment1)
.PARAMETER Command
    The PowerShell command string to execute.
    [comment:2](/docs/references/pipelines/Invoke-AdoScript.ps1.md#comment2)
#>
param(
    [Parameter(Mandatory)]
    [string] $Command,

    [string] $Mode = 'none',
    [switch] $ExposeAccessToken,
    [string] $ServiceConnection,
    [switch] $AllowWarnings
)

. $PSScriptRoot/../importer.ps1 -AllowWarnings:$AllowWarnings

if ($env:SYSTEM_DEBUG -eq 'true') {
    $global:VerbosePreference = 'Continue'
}

trap {
    Write-Exception $_
    break
}

$sanitized = ConvertFrom-AdoPipelineCommand $Command
$modeLabel = if ($Mode -eq 'none') {
    'Invoke-Automation'
}
else {
    "Invoke-Automation [$Mode]"
}
Write-Message $modeLabel
if ($ServiceConnection) {
    Write-Message "ServiceConnection: $ServiceConnection"
}
if ($ExposeAccessToken) {
    Write-Message 'ExposeAccessToken: true'
}

Write-Header -ForegroundColor Green
if ($env:SYSTEM_DEBUG -eq 'true') {
    Write-EnvironmentDiagnostic
}
else {
    Write-AdoEnvironmentDiagnostic
}
Write-Footer -ForegroundColor Green

Write-Header -ForegroundColor DarkBlue
Write-Message $sanitized -NoHeader
Write-Footer -ForegroundColor DarkBlue

Write-Header -ForegroundColor Blue
$block = [ScriptBlock]::Create($sanitized)
Invoke-Command -ScriptBlock $block -NoNewScope
Write-Footer -ForegroundColor Blue
