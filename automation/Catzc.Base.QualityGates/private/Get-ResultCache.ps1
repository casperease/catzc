<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-ResultCache.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-CACHE#10
  config:
    synopsis: 'Reads a quality check''s result cache: which files the check last found clean, keyed on their content.'
    description: |-
      A per-machine file under out/cache/ (gitignored, never committed): repository-relative '/'-separated path ->
      '<file SHA-256>:<stamp>' (Get-ContentStamp over every input that decides the check's verdict), recorded when the
      check last found the file clean ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)). A file
      whose bytes or the check's inputs changed no longer matches its entry and is checked again. A missing or unreadable
      cache is an empty one, so the only cost of losing it is one full check; a pipeline starts with none. Format-Code
      and Get-ScriptAnalyzerDiagnostics keep one each.
    parameters:
      Path: The cache file.
    outputs: '[hashtable] Path -> key.'
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
