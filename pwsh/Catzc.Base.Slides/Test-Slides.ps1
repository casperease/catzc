<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Slides/Test-Slides.ps1
    name: test-slides
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Slides
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1
    docs: "[Test-Slides.ps1.md](docs/references/pwsh/catzc-base-slides/Test-Slides.ps1.md)"
    cites:
      - ADR-REPO-SLIDES-CHECKABLECLAIMS
---
#>

function Test-Slides {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string[]] $Path,

        [string] $Kit = (Get-Config -Config slides).kit,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree
    $kitLoaded = Get-SlidesKit -Kit $Kit -RepositoryRoot $RepositoryRoot
    $suffix = [Catzc.Base.Slides.SlidesConfig]::SlideSuffix

    $files = [System.Collections.Generic.List[string]]::new()
    if (-not $Path -or $Path.Count -eq 0) {
        $docs = Join-Path $RepositoryRoot 'docs'
        if (Test-Path -LiteralPath $docs -PathType Container) {
            foreach ($file in Get-ChildPath $docs -Depth 6 -File -Filter "*$suffix") {
                $files.Add($file)
            }
        }
    }
    else {
        foreach ($item in $Path) {
            $absolute = if ([System.IO.Path]::IsPathRooted($item)) {
                $item
            }
            else {
                Join-Path $RepositoryRoot $item
            }
            Assert-PathExist $absolute -ErrorText "Test-Slides: '$item' is neither a slide file nor a deck folder under the repository root."
            if (Test-Path -LiteralPath $absolute -PathType Container) {
                foreach ($file in Get-ChildPath $absolute -Depth 1 -File -Filter "*$suffix") {
                    $files.Add($file)
                }
            }
            else {
                $files.Add($absolute)
            }
        }
    }

    $issues = [System.Collections.Generic.List[string]]::new()
    foreach ($file in $files) {
        $slide = Read-SlideFile -Path $file
        $page = if ($slide.Order -is [int] -or $slide.Order -is [long]) {
            [int] $slide.Order
        }
        else {
            0
        }
        $finding = Get-SlideFinding -Slide $slide -Kit $kitLoaded -Page $page -RepositoryRoot $RepositoryRoot
        foreach ($fault in $finding.Faults) {
            $issues.Add("$fault")
        }
    }

    $facts = [ordered]@{
        FileCount    = $files.Count
        PatternCount = $kitLoaded.Patterns.Count
    }
    Write-QualityGateReport -Subject slides -Title Test-Slides -Issues $issues.ToArray() -Facts $facts -OutputFolder $OutputFolder -PassThru:$PassThru
}
