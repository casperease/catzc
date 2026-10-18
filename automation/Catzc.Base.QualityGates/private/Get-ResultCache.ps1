<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-ResultCache.ps1
    folder: private
    name: get-result-cache
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    cites:
      - ADR-AUTO-CACHE#10
---
#>

function Get-ResultCache {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    $cache = @{}
    if (-not [System.IO.File]::Exists($Path)) {
        return $cache
    }
    try {
        $parsed = [System.IO.File]::ReadAllText($Path) | ConvertFrom-Json -AsHashtable
    }
    catch {
        Write-Message "Ignoring an unreadable result cache at '$Path': $($_.Exception.Message)"
        return $cache
    }
    foreach ($key in @($parsed.Keys)) {
        if ($parsed[$key] -is [string]) {
            $cache[$key] = $parsed[$key]
        }
    }
    $cache
}
