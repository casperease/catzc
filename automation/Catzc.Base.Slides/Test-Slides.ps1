<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Slides/Test-Slides.ps1
    kind: function
    visibility: public
  edges:
    test: automation/Catzc.Base.Slides/tests/Test-Slides.Tests.ps1
  config:
    synopsis: The slides gate; fails every slide file whose pattern, fields, cited codes or quoted rule text break the rules.
    description: |-
      Runs the checks of Get-SlideFinding over each slide file, one at a time, and reports through the quality-gate report
      (ADR-REPO-SLIDES#4): the head names a pattern the kit holds and a whole-number order; every field fits its pattern and its
      capacity; every cited code is a rule the index knows; a quoted rule is the registry's text verbatim; and every text is in the
      rendered slide. It writes no deck; the render is Build-SlideDeck's.
    parameters:
      Path: Slide files or deck folders, repository-relative or absolute. The default is every slide file under docs/.
      Kit: The slides kit folder, repository-relative. The default is the slides config's kit.
      RepositoryRoot: The repository root the slides and the kit are under.
      OutputFolder: Where the gate report lands. The default is the quality-gate report's own.
      PassThru: Return the report object as well.
    outputs: '[pscustomobject] The quality-gate report, with -PassThru.'
    examples:
      - Test-Slides
      - Test-Slides -Path docs/explanation/thesis/product-thesis
---
#>

function Test-Slides {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
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
