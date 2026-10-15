<#
.SYNOPSIS
    Redirects PowerShell 7's user module path from a network share to a local directory.
.DESCRIPTION
    Enterprise GPOs often redirect the Documents folder to a DFS/UNC share.
    [ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)
    [comment:1](/docs/references/automation/catzc-base-environment/assets/Set-LocalPSModulePath.ps1.md#comment1)
.EXAMPLE
    & 'automation\Catzc.Base.Environment\assets\Set-LocalPSModulePath.ps1'
#>

# One information-stream line, coloured with $PSStyle (catzc's writers are not loaded here).
function Write-SetupLine {
    param([string] $Text, [System.ConsoleColor] $Color = [System.ConsoleColor]::Gray)
    Write-Information "$($PSStyle.Foreground.FromConsoleColor($Color))$Text$($PSStyle.Reset)" -InformationAction Continue
}

$localModulePath = Join-Path $env:LOCALAPPDATA 'PowerShell' 'Modules'

if (-not (Test-Path $localModulePath)) {
    New-Item -Path $localModulePath -ItemType Directory -Force | Out-Null
}

# Use GetFolderPath, not $PROFILE — admin sessions resolve $PROFILE to a different (local) path than the normal user...
# [comment:2](/docs/references/automation/catzc-base-environment/assets/Set-LocalPSModulePath.ps1.md#comment2)
$userConfigDir = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'PowerShell'
if (-not (Test-Path $userConfigDir)) {
    New-Item -Path $userConfigDir -ItemType Directory -Force | Out-Null
}
$userConfigFile = Join-Path $userConfigDir 'powershell.config.json'

if (Test-Path $userConfigFile) {
    $userConfig = Get-Content $userConfigFile -Raw | ConvertFrom-Json
}
else {
    $userConfig = [PSCustomObject]@{}
}

if ($userConfig.PSModulePath -ne $localModulePath) {
    $userConfig | Add-Member -NotePropertyName 'PSModulePath' -NotePropertyValue $localModulePath -Force
    $userConfig | ConvertTo-Json -Depth 10 | Set-Content $userConfigFile -Encoding UTF8
    Write-SetupLine "PSModulePath set to '$localModulePath'" Green
    Write-SetupLine "  Config: $userConfigFile" Gray
}
else {
    Write-SetupLine 'PSModulePath already configured' Green
}

# --- Check for modules left on DFS that should be moved ---
$dfsModulePath = Join-Path $userConfigDir 'Modules'
if ((Test-Path $dfsModulePath) -and (Get-ChildItem $dfsModulePath -Directory -ErrorAction Ignore)) {
    Write-SetupLine ''
    Write-SetupLine "You have modules at '$dfsModulePath' (DFS)." Yellow
    Write-SetupLine 'Move them to the new local path to avoid stale copies:' Yellow
    Write-SetupLine "  Move-Item '$dfsModulePath\*' '$localModulePath' -Force" Cyan
}

Write-SetupLine ''
Write-SetupLine 'Restart PowerShell for changes to take effect.' Cyan
