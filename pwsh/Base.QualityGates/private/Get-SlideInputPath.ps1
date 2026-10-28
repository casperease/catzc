function Get-SlideInputPath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $relative = {
        param([string] $Full)
        [System.IO.Path]::GetFullPath($Full).Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
    }
    $imageOf = {
        param([string] $Text)
        $match = [regex]::Match($Text, '(?m)^## Image[ \t]*\r?\n\s*\[[^\]]*\]\(([^)\s]+)\)')
        if ($match.Success) {
            $match.Groups[1].Value
        }
    }
    $file = Join-Path $root $Path
    $assets = Split-Path $file -Parent
    $deck = Split-Path $assets -Parent
    $leaf = Split-Path $file -Leaf

    if ($leaf.EndsWith('.slide.png', [System.StringComparison]::Ordinal)) {
        $slide = Join-Path $deck "$($leaf.Substring(0, $leaf.Length - '.slide.png'.Length)).slide.md"
        if (-not [System.IO.File]::Exists($slide)) {
            return
        }
        & $relative $slide
        $image = & $imageOf ([System.IO.File]::ReadAllText($slide))
        if ($image) {
            & $relative (Join-Path $deck $image)
        }
        return
    }

    if (-not [System.IO.Directory]::Exists($deck)) {
        return
    }
    # A picture is made for exactly one slide of its deck: the one whose ## Image links it.
    foreach ($slide in [System.IO.Directory]::GetFiles($deck, '*.slide.md')) {
        $text = [System.IO.File]::ReadAllText($slide)
        $image = & $imageOf $text
        if (-not $image -or (& $relative (Join-Path $deck $image)) -cne $Path) {
            continue
        }
        & $relative $slide
        $source = [regex]::Match($text, '(?m)^\s+source:\s*(\S+)')
        if ($source.Success) {
            $picture = & $relative (Join-Path $deck $source.Groups[1].Value)
            $picture
            if ($picture.EndsWith('.drawio.png', [System.StringComparison]::Ordinal)) {
                "$($picture.Substring(0, $picture.Length - 'png'.Length))yml"
            }
        }
        return
    }
}
