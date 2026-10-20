<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-ResultCache.ps1
    folder: private
    name: get-result-cache
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Get-ResultCache.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-ResultCache.ps1.md)"
    cites:
      - ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS
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
