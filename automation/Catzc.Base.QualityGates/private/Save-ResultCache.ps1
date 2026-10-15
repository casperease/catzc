<#
.SYNOPSIS
    Writes a quality check's result cache, sorted by path, merged with what other processes saved meanwhile. See
    Get-ResultCache.
.DESCRIPTION
    The save re-reads the file and keeps other processes' entries, so a plain overwrite cannot drop their saves.
    [ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Save-ResultCache.ps1.md#comment1)
.PARAMETER Path
    The cache file.
.PARAMETER Cache
    Path -> '<file SHA-256>:<stamp>'.
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
