function Get-AdrRuleText {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Code,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $map = Get-AdrCitationMap -RepositoryRoot $RepositoryRoot
    if (-not $map.IsRule($Code)) {
        return $null
    }
    $file = Join-Path $RepositoryRoot ($map.PathOf($Code).TrimStart('/'))
    Assert-PathExist $file -PathType Leaf

    $lines = [System.IO.File]::ReadAllLines($file)
    $heading = "### Rule $Code"
    $index = [Array]::IndexOf($lines, $heading)
    if ($index -lt 0) {
        return $null
    }

    $paragraph = [System.Collections.Generic.List[string]]::new()
    for ($i = $index + 1; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        if ($line.Trim().Length -eq 0) {
            if ($paragraph.Count -gt 0) {
                break
            }
            continue
        }
        if ($line.StartsWith('#', [System.StringComparison]::Ordinal) -or $line.StartsWith('- [', [System.StringComparison]::Ordinal)) {
            break
        }
        $paragraph.Add($line.Trim())
    }

    if ($paragraph.Count -eq 0) {
        return $null
    }
    [Catzc.Base.Slides.SlideSource]::PlainText(($paragraph -join ' '))
}
