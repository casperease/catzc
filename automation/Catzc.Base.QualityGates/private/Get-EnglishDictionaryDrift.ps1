<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-EnglishDictionaryDrift.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
  config:
    synopsis: Reports why the committed English word list is stale, from its stamp alone — no node round-trip.
    description: |-
      Build-EnglishDictionary's -DryRun re-flattens cspell's bundled tries (node, npx, cspell), so the drift check
      reads the committed artifact's stamp instead: the gz and its stamp both exist, the stamp's cspell version
      matches the pinned cspell version, and the stamp's word count matches the gz's line count. Each failure is
      one reason; none means the list is current. Test-GeneratedFiles turns each reason into one issue.
    parameters:
      AssetsFolder: The folder holding english.txt.gz and english.stamp (the QualityGates module's assets/ in the repository).
      PinnedCspell: 'The cspell version tools.yml pins (a prefix: ''10'' matches a stamp of ''10.0.1'').'
    outputs: '[string[]] One reason per drift found; nothing when the committed list is current.'
    examples:
      - Get-EnglishDictionaryDrift -AssetsFolder (Join-Path (Get-RepositoryRoot) 'automation/Catzc.Base.QualityGates/assets') -PinnedCspell '10'
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
