<#
---
catzc:
  derived:
    path: pipelines/Invoke-AdoScript.ps1
    kind: powershell-script
    language: powershell
    track: pipelines
  config:
    synopsis: Universal pipeline entry point. Bootstraps the module system and executes a command.
    description: |-
      Called by the invoke-automation.yaml step template. Imports all modules via
      importer.ps1, sanitizes the command string (YAML/ADO escaping artifacts),
      sets up the error trap, then executes the command.

      The command runs in the same scope as the importer — all functions are available
      without module qualification.
    parameters:
      Command: |-
        The PowerShell command string to execute. This should be the same command a
        developer would type after running .\importer.ps1 locally.
        Supports multiline commands (use YAML pipe operator in the template).
      Mode: A label for the pipeline step's log line; none prints the plain Invoke-Automation label.
      ExposeAccessToken: Reports in the log that the step exposes the pipeline access token to the command.
      ServiceConnection: The name of the service connection the step runs under, reported in the log.
      AllowWarnings: Passed to the importer, which then does not fail the import on a warning.
---
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
