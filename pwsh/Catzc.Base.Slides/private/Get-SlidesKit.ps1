<#
---
catzc:
  immutable:
    with_body_sha: b6a18f645758
  edges:
    docs: "[Get-SlidesKit.ps1.md](docs/references/pwsh/catzc-base-slides/private/Get-SlidesKit.ps1.md)"
    cites:
      - ADR-REPO-SLIDES-PATTERN
---
#>

function Get-SlidesKit {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Kit,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $folder = Join-Path $RepositoryRoot $Kit
    Assert-PathExist $folder -PathType Container -ErrorText "Get-SlidesKit: the slides kit folder '$Kit' does not exist under the repository root."
    $defaultsPath = Join-Path $folder ([Catzc.Base.Slides.SlidesConfig]::KitDefaultsFile)
    Assert-PathExist $defaultsPath -PathType Leaf -ErrorText "Get-SlidesKit: the kit '$Kit' holds no $([Catzc.Base.Slides.SlidesConfig]::KitDefaultsFile)."
    $patternsFolder = Join-Path $folder ([Catzc.Base.Slides.SlidesConfig]::PatternsFolder)
    Assert-PathExist $patternsFolder -PathType Container -ErrorText "Get-SlidesKit: the kit '$Kit' holds no $([Catzc.Base.Slides.SlidesConfig]::PatternsFolder)/ folder."

    $raw = ConvertFrom-Yaml -Yaml ([System.IO.File]::ReadAllText($defaultsPath)) -Ordered
    $config = [Catzc.Base.Slides.SlidesKit]::new($raw)

    $patterns = @{}
    foreach ($file in Get-ChildPath $patternsFolder -Depth 1 -File -Filter '*.html') {
        $name = [System.IO.Path]::GetFileNameWithoutExtension($file)
        $patterns[$name] = [Catzc.Base.Slides.SlidePattern]::Load($name, [System.IO.File]::ReadAllText($file))
    }
    Assert-True ($patterns.Count -gt 0) -ErrorText "Get-SlidesKit: the kit '$Kit' holds no pattern (*.html) under $([Catzc.Base.Slides.SlidesConfig]::PatternsFolder)/."

    [pscustomobject]@{
        Kit      = $Kit
        Folder   = $folder
        Config   = $config
        Patterns = $patterns
    }
}
