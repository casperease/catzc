<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Save-ResultCache.ps1
    folder: private
    name: save-result-cache
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Save-ResultCache.Tests.ps1
    adrs:
      - ADR-AUTO-CACHE#10
  config:
    synopsis: |-
      Writes a quality check's result cache, sorted by path, merged with what other processes saved meanwhile. See
      Get-ResultCache.
    description: |-
      Several processes keep the same cache file: a test run's workers, a person's own checks, a snapshot run handing
      its entries home. Each loads the cache, checks its files, and saves, so a plain overwrite would drop every entry
      another process saved in between. The save therefore re-reads the file and keeps each of its entries for a path
      this cache has no entry for; this cache's own entries win. Keeping another process's entry is always safe: its
      key is the file's content and the check's inputs ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)),
      so it can only match the bytes and inputs it was recorded for.

      The file is replaced in one step (written beside it, then moved over it), so a reader never sees half a file.
      A save that still fails — another process holding the file at that moment — is reported and skipped: the cache
      only saves time, and losing one save costs one more check of those files.
    parameters:
      Path: The cache file.
      Cache: Path -> '<file SHA-256>:<stamp>'.
---
#>

function Save-ResultCache {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Cache
    )

    $merged = Get-ResultCache -Path $Path
    foreach ($key in @($Cache.Keys)) {
        $merged[$key] = $Cache[$key]
    }
    $sorted = [ordered]@{}
    foreach ($key in @($merged.Keys | Sort-Object)) {
        $sorted[$key] = $merged[$key]
    }
    [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Path)) | Out-Null
    $staging = "$Path.$PID.tmp"
    try {
        [System.IO.File]::WriteAllText($staging, (ConvertTo-Json -InputObject $sorted) + "`n", [System.Text.UTF8Encoding]::new($false))
        [System.IO.File]::Move($staging, $Path, $true)
    }
    catch [System.IO.IOException], [System.UnauthorizedAccessException] {
        Write-Message "Skipped saving the result cache at '$Path': $($_.Exception.Message)"
    }
    finally {
        if ([System.IO.File]::Exists($staging)) {
            [System.IO.File]::Delete($staging)
        }
    }
}
