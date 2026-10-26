<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-environment/assets/Set-LocalPSModulePath.ps1.md"
  header: "generated"
---
#>

# catzc's writers are not loaded here, so the one standalone chokepoint, the Loader's Write-ImporterMessage, is imported
# by its path.
if (-not (Get-Command Write-ImporterMessage -ErrorAction Ignore)) {
    Import-Module (Join-Path $PSScriptRoot '../../.internal/Catzc.Internal.Loader.psm1')
}

$localModulePath = Join-Path $env:LOCALAPPDATA 'PowerShell' 'Modules'

if (-not (Test-Path $localModulePath)) {
    New-Item -Path $localModulePath -ItemType Directory -Force | Out-Null
}

# Use GetFolderPath, not $PROFILE — admin sessions resolve $PROFILE to a
# different (local) path than the normal user session (DFS).
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
    Write-ImporterMessage "PSModulePath set to '$localModulePath'" -ForegroundColor Green
    Write-ImporterMessage "  Config: $userConfigFile"
}
else {
    Write-ImporterMessage 'PSModulePath already configured' -ForegroundColor Green
}

# --- Check for modules left on DFS that should be moved ---
$dfsModulePath = Join-Path $userConfigDir 'Modules'
if ([System.IO.Directory]::Exists($dfsModulePath) -and
    [System.IO.Directory]::EnumerateDirectories($dfsModulePath).GetEnumerator().MoveNext()) {
    Write-ImporterMessage ''
    Write-ImporterMessage "You have modules at '$dfsModulePath' (DFS)." -ForegroundColor Yellow
    Write-ImporterMessage 'Move them to the new local path to avoid stale copies:' -ForegroundColor Yellow
    Write-ImporterMessage "  Move-Item '$dfsModulePath\*' '$localModulePath' -Force" -ForegroundColor Cyan
}

Write-ImporterMessage ''
Write-ImporterMessage 'Restart PowerShell for changes to take effect.' -ForegroundColor Cyan
