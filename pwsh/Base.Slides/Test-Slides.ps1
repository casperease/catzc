<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-slides/Test-Slides.ps1.md"
  header: "generated"
---
#>

function Test-Slides {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [Catzc.Base.Asserts.ValidatePathGiven()]
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
    # A deck's order is checked only where every slide of its folder is read; one slide file named alone is no deck.
    $decks = [ordered]@{}
    if (-not $Path -or $Path.Count -eq 0) {
        $docs = Join-Path $RepositoryRoot 'docs'
        if (Test-Path -LiteralPath $docs -PathType Container) {
            foreach ($file in Get-ChildPath $docs -Depth 6 -File -Filter "*$suffix") {
                $files.Add($file)
                $decks[[System.IO.Path]::GetDirectoryName($file)] = $true
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
                    $decks[[System.IO.Path]::GetDirectoryName($file)] = $true
                }
            }
            else {
                $files.Add($absolute)
            }
        }
    }

    $issues = [System.Collections.Generic.List[string]]::new()
    $read = @{}
    foreach ($file in $files) {
        $slide = Read-SlideFile -Path $file
        $read[$file] = $slide
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
    $rootPrefix = $RepositoryRoot.TrimEnd('\', '/')
    foreach ($folder in $decks.Keys) {
        $deck = $folder
        if ($deck.StartsWith($rootPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
            $deck = $deck.Substring($rootPrefix.Length).TrimStart('\', '/')
        }
        $slides = @($files | Where-Object { [System.IO.Path]::GetDirectoryName($_) -eq $folder } |
                ForEach-Object { $read[$_] })
        foreach ($fault in @(Get-SlideOrderFinding -Slide $slides -Deck $deck.Replace('\', '/'))) {
            $issues.Add("$fault")
        }
    }

    $facts = [ordered]@{
        FileCount    = $files.Count
        PatternCount = $kitLoaded.Patterns.Count
    }
    Write-QualityGateReport -Subject slides -Title Test-Slides -Issues $issues.ToArray() -Facts $facts -OutputFolder $OutputFolder -PassThru:$PassThru
}
