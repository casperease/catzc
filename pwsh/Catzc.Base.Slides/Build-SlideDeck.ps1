<#
---
catzc:
  immutable:
    with_body_sha: "2ea5f20f1626"
  edges:
    test: pwsh/Catzc.Base.Slides/tests/Build-SlideDeck.Tests.ps1
    docs: "[Build-SlideDeck.ps1.md](../../docs/references/pwsh/catzc-base-slides/Build-SlideDeck.ps1.md)"
    cites:
      - ADR-REPO-SLIDES-FAILFORWARDRENDER
---
#>

function Build-SlideDeck {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Deck,

        [string] $Kit = (Get-Config -Config slides).kit,

        [string] $Theme = (Get-Config -Config slides).theme,

        [string] $OutputFolder,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $PassThru
    )

    Assert-NotNullOrWhitespace $Deck -ErrorText 'Build-SlideDeck: -Deck names the deck folder, repository-relative.'
    $deckFolder = Join-Path $RepositoryRoot $Deck
    Assert-PathExist $deckFolder -PathType Container -ErrorText "Build-SlideDeck: the deck folder '$Deck' does not exist under the repository root."
    $kitLoaded = Get-SlidesKit -Kit $Kit -RepositoryRoot $RepositoryRoot
    $kitLoaded.Config = $kitLoaded.Config.ForTheme($Theme)
    $deckName = Split-Path $deckFolder -Leaf
    if ([string]::IsNullOrWhiteSpace($OutputFolder)) {
        $themed = if ($Theme -ceq [Catzc.Base.Slides.SlidesConfig]::DefaultTheme) {
            $deckName
        }
        else {
            "$deckName-$Theme"
        }
        $OutputFolder = Join-Path (Join-Path $RepositoryRoot $kitLoaded.Config.Value('render.out')) $themed
    }

    $faults = [System.Collections.Generic.List[Catzc.Base.Slides.SlideFault]]::new()
    $suffix = [Catzc.Base.Slides.SlidesConfig]::SlideSuffix
    $deckFilePath = Join-Path $deckFolder ([Catzc.Base.Slides.SlidesConfig]::DeckFile)
    Assert-PathExist $deckFilePath -PathType Leaf -ErrorText "Build-SlideDeck: the deck folder '$Deck' holds no $([Catzc.Base.Slides.SlidesConfig]::DeckFile)."
    $deckState = Get-MarkdownMetaState -Text ([System.IO.File]::ReadAllText($deckFilePath).Replace("`r`n", "`n"))
    $deckSource = [Catzc.Base.Slides.SlideSource]::Parse($deckState.Body)
    $deckRelative = "$Deck/$([Catzc.Base.Slides.SlidesConfig]::DeckFile)"
    $title = if ($deckSource.Title) {
        $deckSource.Title
    }
    else {
        $deckName
    }
    if (-not $deckSource.Title) {
        $faults.Add([Catzc.Base.Slides.SlideFault]::new($deckRelative, 'title', 'the deck file has a level-one heading, the title of the deck'))
    }
    $sections = [ordered]@{}
    if ($deckSource.Fields.ContainsKey('sections')) {
        foreach ($item in $deckSource.Fields['sections'].Items) {
            $match = [regex]::Match($item.ToString(), '^([A-Za-z0-9_-]+):\s*(.+)$')
            if ($match.Success) {
                $sections[$match.Groups[1].Value] = $match.Groups[2].Value
            }
            else {
                $faults.Add([Catzc.Base.Slides.SlideFault]::new($deckRelative, 'sections', "a section is '<first slide id>: <one sentence>'; found '$item'"))
            }
        }
    }

    $slides = @(Get-ChildPath $deckFolder -Depth 1 -File -Filter "*$suffix" | ForEach-Object { Read-SlideFile -Path $_ })
    Assert-True ($slides.Count -gt 0) -ErrorText "Build-SlideDeck: the deck folder '$Deck' holds no slide file (*$suffix)."
    $ordered = @($slides | Sort-Object { if ($_.Order -is [int] -or $_.Order -is [long]) {
                [long] $_.Order
            }
            else {
                [long]::MaxValue
            } }, Id)
    foreach ($fault in @(Get-SlideOrderFinding -Slide $ordered -Deck $Deck)) {
        $faults.Add($fault)
    }

    $rendered = [System.Collections.Generic.List[pscustomobject]]::new()
    $page = 0
    foreach ($slide in $ordered) {
        $page++
        $finding = Get-SlideFinding -Slide $slide -Kit $kitLoaded -Page $page -RepositoryRoot $RepositoryRoot
        foreach ($fault in $finding.Faults) {
            $faults.Add($fault)
        }
        $rendered.Add([pscustomobject]@{ Slide = $slide; Html = $finding.Html; Page = $page })
    }
    foreach ($start in $sections.Keys) {
        if (-not ($ordered | Where-Object Id -EQ $start)) {
            $faults.Add([Catzc.Base.Slides.SlideFault]::new($deckRelative, 'sections', "the section '$($sections[$start])' starts on '$start', and no slide has that id"))
        }
    }

    $utf8 = [System.Text.UTF8Encoding]::new($false)
    $slidesFolder = Join-Path (Join-Path $OutputFolder 'project') 'slides'
    [System.IO.Directory]::CreateDirectory($slidesFolder) | Out-Null
    foreach ($entry in $rendered) {
        if ($entry.Html) {
            [System.IO.File]::WriteAllText((Join-Path $slidesFolder "$($entry.Slide.Id).html"), $entry.Html + "`n", $utf8)
            # An image the slide shows sits beside its slide file; it lands at the same relative path beside the slide's HTML.
            $slideRelative = [System.IO.Path]::GetRelativePath($RepositoryRoot, $entry.Slide.Path).Replace('\', '/')
            foreach ($match in [regex]::Matches($entry.Html, 'src="([^"]+)"')) {
                $asset = $match.Groups[1].Value
                if ($asset -match '^[a-z][a-z0-9+.-]*:') {
                    continue
                }
                if ([System.IO.Path]::IsPathRooted($asset) -or @($asset -split '[\\/]') -contains '..') {
                    $faults.Add([Catzc.Base.Slides.SlideFault]::new($slideRelative, 'image', "the image '$asset' must sit beside the slide file, a relative path with no '..'"))
                    continue
                }
                $assetSource = Join-Path (Split-Path $entry.Slide.Path -Parent) $asset
                if (-not [System.IO.File]::Exists($assetSource)) {
                    $faults.Add([Catzc.Base.Slides.SlideFault]::new($slideRelative, 'image', "the image '$asset' does not exist beside the slide file"))
                    continue
                }
                $assetTarget = Join-Path $slidesFolder $asset
                [System.IO.Directory]::CreateDirectory((Split-Path $assetTarget -Parent)) | Out-Null
                [System.IO.File]::Copy($assetSource, $assetTarget, $true)
            }
        }
    }

    $faces = [ordered]@{}
    foreach ($family in $kitLoaded.Config.Families()) {
        $face = [ordered]@{ family = $family.Key }
        if ($family.Value) {
            $face['href'] = $family.Value
        }
        $faces[$family.Key.ToLowerInvariant().Replace(' ', '-')] = $face
    }
    $sectionIndex = [ordered]@{}
    foreach ($start in $sections.Keys) {
        $sectionIndex[$start] = [ordered]@{ description = $sections[$start]; start = $start }
    }
    $index = [ordered]@{
        v              = 4
        createdOnFiles = [ordered]@{ v = 1; at = [DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ', [System.Globalization.CultureInfo]::InvariantCulture) }
        lists          = 'css'
        title          = $title
        order          = [string[]] @($rendered | ForEach-Object { $_.Slide.Id })
        sections       = $sectionIndex
        faces          = $faces
        designSystems  = @()
    }
    [System.IO.File]::WriteAllText((Join-Path (Join-Path $OutputFolder 'project') 'deck.json'), ($index | ConvertTo-Json -Depth 6) + "`n", $utf8)

    $script = [System.Text.StringBuilder]::new()
    [void] $script.AppendLine("# $title").AppendLine()
    foreach ($entry in $rendered) {
        $notes = if ($entry.Slide.Source.Fields.ContainsKey('notes')) {
            @($entry.Slide.Source.Fields['notes'].Items | ForEach-Object ToString) -join "`n`n"
        }
        else {
            ''
        }
        [void] $script.AppendLine("**$($entry.Page). $($entry.Slide.Source.Title)**").AppendLine()
        if ($notes) {
            [void] $script.AppendLine($notes).AppendLine()
        }
    }
    [System.IO.File]::WriteAllText((Join-Path $OutputFolder "$deckName.script.md"), $script.ToString(), $utf8)

    $faultLines = if ($faults.Count -eq 0) {
        @('No faults.')
    }
    else {
        @($faults | ForEach-Object { "- $_" })
    }
    [System.IO.File]::WriteAllText((Join-Path $OutputFolder "$deckName.faults.md"), (@("# Faults of $deckName", '') + $faultLines -join "`n") + "`n", $utf8)

    Write-Message "[Build-SlideDeck] ${deckName}: $($rendered.Count) slide(s) rendered to $OutputFolder, $($faults.Count) fault(s)."
    if ($PassThru) {
        [pscustomobject]@{
            Deck         = $Deck
            Title        = $title
            SlideCount   = $rendered.Count
            Faults       = $faults.ToArray()
            OutputFolder = $OutputFolder
        }
    }
}
