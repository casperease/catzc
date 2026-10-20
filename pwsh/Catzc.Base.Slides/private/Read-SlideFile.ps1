<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Slides/private/Read-SlideFile.ps1
    folder: private
    name: read-slide-file
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Slides
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
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
    $cites = @()
    if ($state.HasFrontMatter) {
        $match = [regex]::Match($text, '\A---\n(.*?)\n---(?:\n|\z)', [System.Text.RegularExpressions.RegexOptions]::Singleline)
        if ($match.Success) {
            $frontMatter = ConvertFrom-Yaml -Yaml $match.Groups[1].Value -Ordered
            if ($frontMatter -is [System.Collections.IDictionary] -and $frontMatter.Contains('catzc') -and $frontMatter['catzc'] -is [System.Collections.IDictionary]) {
                $catzc = $frontMatter['catzc']
                if ($catzc.Contains('config') -and $catzc['config'] -is [System.Collections.IDictionary]) {
                    $config = $catzc['config']
                }
                if ($catzc.Contains('edges') -and $catzc['edges'] -is [System.Collections.IDictionary] -and $catzc['edges'].Contains('cites') -and $null -ne $catzc['edges']['cites']) {
                    $cites = @($catzc['edges']['cites'])
                }
            }
        }
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
        Cites   = [string[]] @($cites | ForEach-Object { "$_" })
        Source  = [Catzc.Base.Slides.SlideSource]::Parse($state.Body)
    }
}
