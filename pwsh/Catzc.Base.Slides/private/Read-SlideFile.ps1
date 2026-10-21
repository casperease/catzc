<#
---
catzc:
  immutable:
    with_body_sha: b3c9dfb5cce4
  edges:
    docs: "[Read-SlideFile.ps1.md](docs/references/pwsh/catzc-base-slides/private/Read-SlideFile.ps1.md)"
    cites:
      - ADR-REPO-SLIDES-SLIDEFILE
---
#>

function Read-SlideFile {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    Assert-PathExist $Path -PathType Leaf
    $text = [System.IO.File]::ReadAllText($Path).Replace("`r`n", "`n")
    $state = Get-MarkdownMetaState -Text $text

    $config = [ordered]@{}
    if ($state.HasFrontMatter) {
        $match = [regex]::Match($text, '\A---\n(.*?)\n---(?:\n|\z)', [System.Text.RegularExpressions.RegexOptions]::Singleline)
        if ($match.Success) {
            $frontMatter = ConvertFrom-Yaml -Yaml $match.Groups[1].Value -Ordered
            if ($frontMatter -is [System.Collections.IDictionary] -and $frontMatter.Contains('catzc') -and $frontMatter['catzc'] -is [System.Collections.IDictionary]) {
                $catzc = $frontMatter['catzc']
                if ($catzc.Contains('config') -and $catzc['config'] -is [System.Collections.IDictionary]) {
                    $config = $catzc['config']
                }
            }
        }
    }
    # The cites come from the slide's text, the way the drs-codes processor finds them; the head is never read back.
    $cites = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($found in [regex]::Matches($state.Body, "(?<![\w-])$((Get-Config -Config drs).CodeForm.Cited)(?![\w#-]|:\d)")) {
        [void] $cites.Add($found.Value)
    }

    $value = {
        param([string] $Key)
        if ($config.Contains($Key) -and $null -ne $config[$Key]) {
            $config[$Key]
        }
    }
    $stem = [System.IO.Path]::GetFileName($Path)
    $suffix = [Catzc.Base.Slides.SlidesConfig]::SlideSuffix
    if ($stem.EndsWith($suffix, [System.StringComparison]::Ordinal)) {
        $stem = $stem.Substring(0, $stem.Length - $suffix.Length)
    }

    [pscustomobject]@{
        Path    = $Path
        Id      = $stem
        Pattern = [string] (& $value 'pattern')
        Deck    = [string] (& $value 'deck')
        Order   = & $value 'order'
        Quotes  = [string] (& $value 'quotes')
        Cites   = [string[]] @($cites)
        Source  = [Catzc.Base.Slides.SlideSource]::Parse($state.Body)
    }
}
