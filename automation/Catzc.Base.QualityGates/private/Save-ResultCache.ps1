<#
.SYNOPSIS
    Writes a quality check's result cache, sorted by path. See Get-ResultCache.
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

    $sorted = [ordered]@{}
    foreach ($key in @($Cache.Keys | Sort-Object)) {
        $sorted[$key] = $Cache[$key]
    }
    [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Path)) | Out-Null
    [System.IO.File]::WriteAllText($Path, (ConvertTo-Json -InputObject $sorted) + "`n", [System.Text.UTF8Encoding]::new($false))
}
