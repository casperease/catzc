function Get-EnglishDictionaryDrift {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $AssetsFolder,

        [Parameter(Mandatory)]
        [string] $PinnedCspell
    )

    $gzipPath = [Catzc.Base.QualityGates.SpellingOracle]::DictionaryPath($AssetsFolder)
    $stampPath = [Catzc.Base.QualityGates.SpellingOracle]::DictionaryStampPath($AssetsFolder)

    $missing = @(foreach ($path in $gzipPath, $stampPath) {
            if (-not [System.IO.File]::Exists($path)) {
                "$([System.IO.Path]::GetFileName($path)) is missing"
            }
        })
    if ($missing.Count -gt 0) {
        return [string[]] $missing
    }

    $stamp = [System.IO.File]::ReadAllText($stampPath) | ConvertFrom-Json -AsHashtable
    $reasons = [System.Collections.Generic.List[string]]::new()

    $flattenedFrom = "$($stamp['cspell'])"
    if (-not $flattenedFrom.StartsWith($PinnedCspell)) {
        $reasons.Add("flattened from cspell '$flattenedFrom' but tools.yml pins '$PinnedCspell'")
    }

    $text = [System.Text.Encoding]::UTF8.GetString([Catzc.Base.QualityGates.GzipText]::Decompress([System.IO.File]::ReadAllBytes($gzipPath)))
    $actual = @($text -split "`n" | Where-Object { $_ }).Count
    if ("$actual" -ne "$($stamp['word_count'])") {
        $reasons.Add("holds $actual word(s) but its stamp records $($stamp['word_count'])")
    }

    [string[]] $reasons.ToArray()
}
