Describe 'Build-SlideDeck' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES#1', 'ADR-REPO-SLIDES#3', 'ADR-REPO-SLIDES#4' {
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
  edges:
    cites: [ADR-WIDGET-GADGET#2]
  config:
    pattern: widget
    deck: gadget-deck
    order: $Order
$Extra
---

# $Title

## Eyebrow

ADR-WIDGET-GADGET#2 · Widgets

## Body

$Body

## Notes

Notes for $Id.
"@
        }
        & $write 'decks/gadget-deck/deck.md' "# The gadget deck`n`n## Sections`n`n- one: Why the widget spins.`n- two: What it rests on.`n"
        & $write 'decks/gadget-deck/one.slide.md' (& $slide 'one' 1 'The widget spins' 'A widget spins when wound.' '    quotes: ADR-WIDGET-GADGET#2')
        & $write 'decks/gadget-deck/two.slide.md' (& $slide 'two' 2 'The gadget rests' 'A gadget rests on the widget.')
        Mock Get-AdrRuleText -ModuleName Catzc.Base.Slides {
            param([string] $Code)
            if ($Code -in 'ADR-WIDGET-GADGET#1', 'ADR-WIDGET-GADGET#2') {
                'A widget spins when wound.'
            }
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

    It 'reports a duplicate order and a gap, and still renders every slide' -Tag 'ADR-REPO-SLIDES#1' {
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

    It 'reports a quoted rule that differs from the registry, a cite the index does not know, and a section starting on no slide' -Tag 'ADR-REPO-SLIDES#4' {
        & $write 'decks/drift-deck/deck.md' "# Drift`n`n## Sections`n`n- nowhere: Starts on no slide.`n"
        & $write 'decks/drift-deck/d.slide.md' ((& $slide 'd' 1 'D' 'A widget spins when it feels like it.' '    quotes: ADR-WIDGET-GADGET#2').Replace('cites: [ADR-WIDGET-GADGET#2]', 'cites: [ADR-WIDGET-GADGET#2, ADR-WIDGET-GADGET#9, ADR-WIDGET-GADGET, "ADR-WIDGET-GADGET#{1-2}", gadget]'))
        $faults = @((Build-SlideDeck -Deck 'decks/drift-deck' -Kit 'kit' -RepositoryRoot $root -PassThru).Faults | ForEach-Object ToString)
        ($faults -join "`n") | Should -Not -Match "'ADR-WIDGET-GADGET'|'ADR-WIDGET-GADGET#\{1-2\}'"
        $faults | Should -Contain "decks/drift-deck/d.slide.md: field 'cites': 'gadget' is not a citation of the form ADR-NAME, ADR-NAME#n or ADR-NAME#{n-m}"
        ($faults -join "`n") | Should -Match "d\.slide\.md: field 'body': quotes ADR-WIDGET-GADGET#2 but differs from the registry\."
        ($faults -join "`n") | Should -Match 'registry: A widget spins when wound\.'
        $faults | Should -Contain "decks/drift-deck/d.slide.md: field 'cites': the ADR index knows no rule 'ADR-WIDGET-GADGET#9'"
        $faults | Should -Contain "decks/drift-deck/deck.md: field 'sections': the section 'Starts on no slide.' starts on 'nowhere', and no slide has that id"
    }

    It 'reports a slide whose head names no pattern, or a pattern the kit does not hold, and a non-numeric order' -Tag 'ADR-REPO-SLIDES#2' {
        & $write 'decks/pattern-deck/deck.md' "# Patterns`n"
        & $write 'decks/pattern-deck/e.slide.md' (& $slide 'e' 1 'E' 'e.').Replace('pattern: widget', 'pattern: gadget')
        & $write 'decks/pattern-deck/f.slide.md' (& $slide 'f' 2 'F' 'f.').Replace("    pattern: widget`n", '').Replace('order: 2', 'order: second')
        $faults = @((Build-SlideDeck -Deck 'decks/pattern-deck' -Kit 'kit' -RepositoryRoot $root -PassThru).Faults | ForEach-Object ToString)
        $faults | Should -Contain "decks/pattern-deck/e.slide.md: field 'pattern': the kit 'kit' holds no pattern 'gadget'; it holds: widget"
        $faults | Should -Contain "decks/pattern-deck/f.slide.md: field 'pattern': the head names no pattern (config.pattern); the kit holds: widget"
        $faults | Should -Contain "decks/pattern-deck/f.slide.md: field 'order': the head's config.order is a whole number from 1; found 'second'"
    }

    It 'fails fast on a deck folder that does not exist, a deck with no deck file, and a deck with no slide' -Tag 'ADR-AUTO-FAILFAST#1' {
        { Build-SlideDeck -Deck 'decks/missing' -Kit 'kit' -RepositoryRoot $root } | Should -Throw '*does not exist*'
        & $write 'decks/empty-deck/stray.md' 'x'
        { Build-SlideDeck -Deck 'decks/empty-deck' -Kit 'kit' -RepositoryRoot $root } | Should -Throw '*holds no deck.md*'
        & $write 'decks/empty-deck/deck.md' "# Empty`n"
        { Build-SlideDeck -Deck 'decks/empty-deck' -Kit 'kit' -RepositoryRoot $root } | Should -Throw '*holds no slide file*'
    }

    It 'fails fast on a kit with no patterns folder' -Tag 'ADR-AUTO-FAILFAST#1' {
        & $write 'bare-kit/slides.yml' "face:`n  display: Georgia, serif`n  text: Arial, sans-serif`n"
        { Build-SlideDeck -Deck 'decks/gadget-deck' -Kit 'bare-kit' -RepositoryRoot $root } | Should -Throw '*holds no patterns/ folder*'
    }
}
