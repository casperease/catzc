<#
---
catzc:
  immutable:
    with_body_sha: a17ad2b53d4e
  edges:
    code: pwsh/Catzc.Base.Slides/Build-SlideDeck.ps1
    cites:
      - ADR-AUTO-FAILFAST-ASSERTINPUTSATENTRY
      - ADR-REPO-FILEMETA-NOREADBACK
      - ADR-REPO-SLIDES-SLIDEFILE
      - ADR-REPO-SLIDES-PATTERN
      - ADR-REPO-SLIDES-FAILFORWARDRENDER
      - ADR-REPO-SLIDES-CHECKABLECLAIMS
---
#>

Describe 'Build-SlideDeck' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES-SLIDEFILE', 'ADR-REPO-SLIDES-FAILFORWARDRENDER', 'ADR-REPO-SLIDES-CHECKABLECLAIMS' {
    BeforeAll {
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:root = $root
        $write = {
            param([string] $Relative, [string] $Content)
            $full = Join-Path $root $Relative
            [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($full, $Content)
        }
        $script:write = $write
        & $write 'kit/slides.yml' @'
token:
  bg: "#101010"
  accent: "#ABCDEF"
face:
  display: "'Widget Serif', Georgia, serif"
  display_href: https://fonts.example/widget
  text: Arial, sans-serif
scale:
  h2: 72
render:
  out: out/gadget-slides
'@
        & $write 'kit/patterns/widget.html' @'
<section id="{{@id}}" style="background:{{@token.bg}};font-family:{{@face.text}}">
<p style="color:{{@token.accent}}">{{eyebrow}}</p>
<h2 style="font-size:{{@scale.h2}}px">{{title}}</h2>
<div data-field="body" data-max="2"><p data-item>{{item}}</p></div>
<p>{{@page}}</p>
<aside>{{notes?}}</aside>
</section>
'@
        $script:slide = {
            param([string] $Id, [int] $Order, [string] $Title, [string] $Body, [string] $Extra = '')
            @"
---
catzc:
  config:
    pattern: widget
    deck: gadget-deck
    order: $Order
$Extra
---

# $Title

## Eyebrow

ADR-WIDGET-GADGET-SPIN · Widgets

## Body

$Body

## Notes

Notes for $Id.
"@
        }
        & $write 'decks/gadget-deck/deck.md' "# The gadget deck`n`n## Sections`n`n- one: Why the widget spins.`n- two: What it rests on.`n"
        & $write 'decks/gadget-deck/one.slide.md' (& $slide 'one' 1 'The widget spins' 'A widget spins when wound.' '    quotes: ADR-WIDGET-GADGET-SPIN')
        & $write 'decks/gadget-deck/two.slide.md' (& $slide 'two' 2 'The gadget rests' 'A gadget rests on the widget.')
        Mock Get-AdrRuleText -ModuleName Catzc.Base.Slides {
            param([string] $Code)
            if ($Code -in 'ADR-WIDGET-GADGET-TURN', 'ADR-WIDGET-GADGET-SPIN') {
                'A widget spins when wound.'
            }
        }
        # The index the slides' cites are checked against: one ADR and its two rules.
        Mock Get-AdrCitationMap -ModuleName Catzc.Base.Slides {
            [Catzc.Base.Docs.AdrCitationMap]::new(
                @{ 'ADR-WIDGET-GADGET' = @{ path = 'docs/drs/widget/gadget.md'; rules = [string[]] @('ADR-WIDGET-GADGET-TURN', 'ADR-WIDGET-GADGET-SPIN') } }, $null)
        }
        Mock Write-Message -ModuleName Catzc.Base.Slides {}
    }

    It 'renders every slide of the deck into the artifact tree, the script and the faults file, and reports no fault' {
        $result = Build-SlideDeck -Deck 'decks/gadget-deck' -Kit 'kit' -RepositoryRoot $root -PassThru
        $result.SlideCount | Should -Be 2
        $result.Title | Should -Be 'The gadget deck'
        @($result.Faults) | Should -BeNullOrEmpty
        $result.OutputFolder | Should -Be (Join-Path $root 'out/gadget-slides/gadget-deck')
        $index = Get-Content (Join-Path $result.OutputFolder 'project/deck.json') -Raw | ConvertFrom-Json
        $index.v | Should -Be 4
        $index.title | Should -Be 'The gadget deck'
        @($index.order) | Should -Be @('one', 'two')
        $index.sections.one.description | Should -Be 'Why the widget spins.'
        $index.sections.two.start | Should -Be 'two'
        $index.faces.'widget-serif'.href | Should -Be 'https://fonts.example/widget'
        $index.faces.arial.family | Should -Be 'Arial'
        $one = Get-Content (Join-Path $result.OutputFolder 'project/slides/one.slide.html' -ErrorAction SilentlyContinue) -Raw -ErrorAction SilentlyContinue
        $one | Should -BeNullOrEmpty
        $one = Get-Content (Join-Path $result.OutputFolder 'project/slides/one.html') -Raw
        $one | Should -Match '^<section id="one" style="background:#101010;font-family:Arial, sans-serif">'
        $one | Should -Match '<p>1</p>'
        $one | Should -Match '<aside>Notes for one.</aside>'
        $script = Get-Content (Join-Path $result.OutputFolder 'gadget-deck.script.md') -Raw
        $script | Should -Match '# The gadget deck'
        $script | Should -Match '\*\*1\. The widget spins\*\*\s+Notes for one\.'
        $script | Should -Match '\*\*2\. The gadget rests\*\*'
        Get-Content (Join-Path $result.OutputFolder 'gadget-deck.faults.md') -Raw | Should -Match 'No faults\.'
    }

    It 'writes to the output folder it is given' {
        $out = Join-Path $root 'elsewhere'
        $result = Build-SlideDeck -Deck 'decks/gadget-deck' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out -PassThru
        $result.OutputFolder | Should -Be $out
        Test-Path (Join-Path $out 'project/deck.json') | Should -BeTrue
    }

    It 'renders an image slide: fills the src from the slide, copies the png beside the slide HTML, and faults a path that leaves the slide folder or is missing' -Tag 'ADR-REPO-SLIDES-PATTERN' {
        # A kit of its own, so the shared kit's pattern list stays as the other tests expect it.
        & $write 'image-kit/slides.yml' (Get-Content (Join-Path $root 'kit/slides.yml') -Raw)
        & $write 'image-kit/patterns/gadget-image.html' "<section id=`"{{@id}}`"><h2>{{title}}</h2><img src=`"{{image}}`" alt=`"{{title}}`" /><p>{{caption}}</p><aside>{{notes?}}</aside></section>`n"
        $imageSlide = {
            param([string] $Id, [int] $Order, [string] $Image)
            "---`ncatzc:`n  config:`n    pattern: gadget-image`n    deck: image-deck`n    order: $Order`n---`n`n# The gadget $Id`n`n## Image`n`n$Image`n`n## Caption`n`nThe gadget, drawn.`n"
        }
        & $write 'decks/image-deck/deck.md' "# Images`n"
        & $write 'decks/image-deck/.assets/gadget/gadget.png' 'not really a png'
        & $write 'decks/image-deck/shown.slide.md' (& $imageSlide 'shown' 1 '.assets/gadget/gadget.png')
        & $write 'decks/image-deck/escaping.slide.md' (& $imageSlide 'escaping' 2 '../gadget-deck/gadget.png')
        & $write 'decks/image-deck/missing.slide.md' (& $imageSlide 'missing' 3 '.assets/gadget/widget.png')
        $result = Build-SlideDeck -Deck 'decks/image-deck' -Kit 'image-kit' -RepositoryRoot $root -PassThru

        $shown = Get-Content (Join-Path $result.OutputFolder 'project/slides/shown.html') -Raw
        $shown | Should -Match '<img src="\.assets/gadget/gadget\.png" alt="The gadget shown"'
        $shown | Should -Match '<p>The gadget, drawn\.</p>'
        Get-Content (Join-Path $result.OutputFolder 'project/slides/.assets/gadget/gadget.png') -Raw | Should -BeExactly 'not really a png'
        $faults = @($result.Faults | ForEach-Object ToString)
        $faults.Count | Should -Be 2 -Because ($faults -join "`n")
        ($faults -join "`n") | Should -Match "decks/image-deck/escaping\.slide\.md: field 'image': the image '\.\./gadget-deck/gadget\.png' must sit beside the slide file"
        ($faults -join "`n") | Should -Match "decks/image-deck/missing\.slide\.md: field 'image': the image '\.assets/gadget/widget\.png' does not exist beside the slide file"
    }

    It 'reports a duplicate order and a gap, and still renders every slide' -Tag 'ADR-REPO-SLIDES-SLIDEFILE' {
        & $write 'decks/gap-deck/deck.md' "# Gaps`n"
        & $write 'decks/gap-deck/a.slide.md' (& $slide 'a' 1 'A' 'a.')
        & $write 'decks/gap-deck/b.slide.md' (& $slide 'b' 1 'B' 'b.')
        & $write 'decks/gap-deck/c.slide.md' (& $slide 'c' 4 'C' 'c.')
        $result = Build-SlideDeck -Deck 'decks/gap-deck' -Kit 'kit' -RepositoryRoot $root -PassThru
        $faults = @($result.Faults | ForEach-Object ToString)
        $faults | Should -Contain "decks/gap-deck: field 'order': the order 1 is held by 2 slides: a, b"
        ($faults -join "`n") | Should -Match "field 'order': the orders have a gap: expected 2, found 4"
        $result.SlideCount | Should -Be 3
        Test-Path (Join-Path $result.OutputFolder 'project/slides/c.html') | Should -BeTrue
        Get-Content (Join-Path $result.OutputFolder 'gap-deck.faults.md') -Raw | Should -Match 'the order 1 is held by 2 slides'
    }

    It 'reports a quoted rule that differs from the registry, a cite the index does not know, and a section starting on no slide' -Tag 'ADR-REPO-SLIDES-CHECKABLECLAIMS' {
        & $write 'decks/drift-deck/deck.md' "# Drift`n`n## Sections`n`n- nowhere: Starts on no slide.`n"
        & $write 'decks/drift-deck/d.slide.md' ((& $slide 'd' 1 'D' 'A widget spins when it feels like it.' '    quotes: ADR-WIDGET-GADGET-SPIN').Replace('ADR-WIDGET-GADGET-SPIN · Widgets', 'ADR-WIDGET-GADGET-SPIN, ADR-WIDGET-GADGET-GHOST, ADR-WIDGET-GADGET and ADR-WIDGET-GADGET#{1-2} · Widgets'))
        $faults = @((Build-SlideDeck -Deck 'decks/drift-deck' -Kit 'kit' -RepositoryRoot $root -PassThru).Faults | ForEach-Object ToString)
        # An ADR code in the text is a cite like a rule code; a group of numbers is no code, so it is no cite.
        ($faults -join "`n") | Should -Not -Match "'ADR-WIDGET-GADGET'"
        ($faults -join "`n") | Should -Not -Match '#\{1-2\}'
        ($faults -join "`n") | Should -Match "d\.slide\.md: field 'body': quotes ADR-WIDGET-GADGET-SPIN but differs from the registry\."
        ($faults -join "`n") | Should -Match 'registry: A widget spins when wound\.'
        $faults | Should -Contain "decks/drift-deck/d.slide.md: field 'cites': the ADR index knows no ADR or rule 'ADR-WIDGET-GADGET-GHOST'"
        $faults | Should -Contain "decks/drift-deck/deck.md: field 'sections': the section 'Starts on no slide.' starts on 'nowhere', and no slide has that id"
    }

    It 'never reads a cite back from the head' -Tag 'ADR-REPO-FILEMETA-NOREADBACK' {
        & $write 'decks/head-deck/deck.md' "# Head`n"
        & $write 'decks/head-deck/h.slide.md' ((& $slide 'h' 1 'H' 'h.') -replace 'catzc:\r?\n', "catzc:`n  edges:`n    cites: [ADR-WIDGET-GADGET-GHOST]`n")
        $faults = @((Build-SlideDeck -Deck 'decks/head-deck' -Kit 'kit' -RepositoryRoot $root -PassThru).Faults | ForEach-Object ToString)
        ($faults -join "`n") | Should -Not -Match 'GHOST'
    }

    It 'reports a slide whose head names no pattern, or a pattern the kit does not hold, and a non-numeric order' -Tag 'ADR-REPO-SLIDES-PATTERN' {
        & $write 'decks/pattern-deck/deck.md' "# Patterns`n"
        & $write 'decks/pattern-deck/e.slide.md' (& $slide 'e' 1 'E' 'e.').Replace('pattern: widget', 'pattern: gadget')
        & $write 'decks/pattern-deck/f.slide.md' (& $slide 'f' 2 'F' 'f.').Replace("    pattern: widget`n", '').Replace('order: 2', 'order: second')
        $faults = @((Build-SlideDeck -Deck 'decks/pattern-deck' -Kit 'kit' -RepositoryRoot $root -PassThru).Faults | ForEach-Object ToString)
        $faults | Should -Contain "decks/pattern-deck/e.slide.md: field 'pattern': the kit 'kit' holds no pattern 'gadget'; it holds: widget"
        $faults | Should -Contain "decks/pattern-deck/f.slide.md: field 'pattern': the head names no pattern (config.pattern); the kit holds: widget"
        $faults | Should -Contain "decks/pattern-deck/f.slide.md: field 'order': the head's config.order is a whole number from 1; found 'second'"
    }

    It 'fails fast on a deck folder that does not exist, a deck with no deck file, and a deck with no slide' -Tag 'ADR-AUTO-FAILFAST-ASSERTINPUTSATENTRY' {
        { Build-SlideDeck -Deck 'decks/missing' -Kit 'kit' -RepositoryRoot $root } | Should -Throw '*does not exist*'
        & $write 'decks/empty-deck/stray.md' 'x'
        { Build-SlideDeck -Deck 'decks/empty-deck' -Kit 'kit' -RepositoryRoot $root } | Should -Throw '*holds no deck.md*'
        & $write 'decks/empty-deck/deck.md' "# Empty`n"
        { Build-SlideDeck -Deck 'decks/empty-deck' -Kit 'kit' -RepositoryRoot $root } | Should -Throw '*holds no slide file*'
    }

    It 'fails fast on a kit with no patterns folder' -Tag 'ADR-AUTO-FAILFAST-ASSERTINPUTSATENTRY' {
        & $write 'bare-kit/slides.yml' "face:`n  display: Georgia, serif`n  text: Arial, sans-serif`n"
        { Build-SlideDeck -Deck 'decks/gadget-deck' -Kit 'bare-kit' -RepositoryRoot $root } | Should -Throw '*holds no patterns/ folder*'
    }
}
