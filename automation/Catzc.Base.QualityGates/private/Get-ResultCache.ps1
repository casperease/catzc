# catzc:
#   path: automation/Catzc.Base.QualityGates/private/Get-ResultCache.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    Reads a quality check's result cache: which files the check last found clean, keyed on their content.
.DESCRIPTION
    A missing or unreadable cache reads as empty, so losing it costs only one full check; a pipeline starts with none.
    [ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-ResultCache.ps1.md#comment1)
.PARAMETER Path
    The cache file.
.OUTPUTS
    [hashtable] Path -> key.
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
