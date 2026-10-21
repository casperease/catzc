<#
---
catzc:
  immutable:
    with_body_sha: "2de0a84ddc56"
  edges:
    docs: "[Get-EnglishDictionaryDrift.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-EnglishDictionaryDrift.ps1.md)"
---
#>

function Get-EnglishDictionaryDrift {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $AssetsFolder,

        [Parameter(Mandatory)]
        [string] $PinnedCspell
    )

    $gzipPath = Join-Path $AssetsFolder 'english.txt.gz'
    $stampPath = Join-Path $AssetsFolder 'english.stamp'

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
