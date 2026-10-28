Describe 'Test-Slides' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES-CHECKABLECLAIMS' {
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
        & $write 'docs/drs/index.md' "# DRS index`n`n| Code | Record |`n| --- | --- |`n| ``ADR-WIDGET-GADGET`` | [gadget](widget/gadget.md) |`n"
        & $write 'docs/drs/widget/gadget.md' "# Design: gadget`n`n## Rules: ADR-WIDGET-GADGET`n`n### Rule ADR-WIDGET-GADGET-TURN`n`nA gadget turns.`n`n### Rule ADR-WIDGET-GADGET-SPIN`n`nA gadget spins round and round.`n"
        & $write 'kit/slides.yml' "token:`n  bg: '#101010'`nface:`n  display: Georgia, serif`n  text: Arial, sans-serif`n"
        & $write 'kit/patterns/widget.html' '<section id="{{@id}}" style="background:{{@token.bg}}"><h2>{{title}}</h2><div data-field="body" data-max="1" data-max-words="5"><p data-item>{{item}}</p></div><p>{{@page}}</p></section>'
        $script:slide = {
            param([int] $Order, [string] $Title, [string] $Body, [string] $Pattern = 'widget')
            "---`ncatzc:`n  config:`n    pattern: $Pattern`n    deck: gadget-deck`n    order: $Order`n---`n`n# $Title`n`n## Body`n`n$Body`n"
        }
        & $write 'docs/decks/gadget-deck/one.slide.md' (& $slide 1 'One' 'a.')
        & $write 'docs/decks/gadget-deck/two.slide.md' (& $slide 2 'Two' 'b.')
        & $write 'docs/decks/broken-deck/three.slide.md' (& $slide 1 'Three' "c.`n`nd." 'gadget')
        & $write 'quotes/four.slide.md' "---`ncatzc:`n  config:`n    pattern: widget`n    deck: quote-deck`n    order: 1`n    quotes: ADR-WIDGET-GADGET-SPIN`n---`n`n# Four`n`n## Body`n`nA gadget spins round and round.`n"
        Mock Assert-SourceTree -ModuleName Catzc.Base.Slides {}
        $script:out = Join-Path $root 'out'
    }

    It 'passes a clean slide file, and a deck folder of clean slides' {
        { Test-Slides -Path 'docs/decks/gadget-deck/one.slide.md' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out } | Should -Not -Throw
        $report = Test-Slides -Path 'docs/decks/gadget-deck' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out -PassThru
        $report.IssueCount | Should -Be 0
        $report.Facts['FileCount'] | Should -Be 2
        $report.Facts['PatternCount'] | Should -Be 1
    }

    It 'fails a slide whose pattern the kit does not hold, naming the file and the field' {
        { Test-Slides -Path 'docs/decks/broken-deck' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out } |
            Should -Throw '*Test-Slides failed: 1 issue(s)*'
        $report = Test-Slides -Path 'docs/decks/broken-deck' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out -PassThru
        $report.IssueCount | Should -Be 1
        $report.Issues[0] |
            Should -Be "docs/decks/broken-deck/three.slide.md: field 'pattern': the kit 'kit' holds no pattern 'gadget'; it holds: widget"
    }

    It 'names the quoted rule as the thing to trim when the rule is longer than the pattern holds' {
        $report = Test-Slides -Path 'quotes/four.slide.md' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out -PassThru
        $report.Issues |
            Should -Contain "quotes/four.slide.md: field 'quotes': the quoted rule ADR-WIDGET-GADGET-SPIN is 6 words; pattern 'widget' holds at most 5, so the rule itself must be trimmed"
    }

    It 'checks every slide file under docs when no path is given' {
        { Test-Slides -Kit 'kit' -RepositoryRoot $root -OutputFolder $out } |
            Should -Throw '*Test-Slides failed: 1 issue(s)*'
    }

    It 'reports a gap in the orders of a deck folder it reads whole, and never of one slide file named alone' -Tag 'ADR-REPO-SLIDES-SLIDEFILE' {
        & $write 'gaps/gap-deck/one.slide.md' (& $slide 1 'One' 'a.')
        & $write 'gaps/gap-deck/three.slide.md' (& $slide 3 'Three' 'c.')
        $report = Test-Slides -Path 'gaps/gap-deck' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out -PassThru
        $report.Issues | Should -Be @("gaps/gap-deck: field 'order': the orders have a gap: expected 2, found 3")
        $alone = Test-Slides -Path 'gaps/gap-deck/three.slide.md' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out -PassThru
        $alone.IssueCount | Should -Be 0
    }

    It 'fails fast on a path that is neither a slide file nor a deck folder' -Tag 'ADR-AUTO-FAILFAST-ASSERTINPUTSATENTRY' {
        { Test-Slides -Path 'docs/decks/missing' -Kit 'kit' -RepositoryRoot $root -OutputFolder $out } |
            Should -Throw '*neither a slide file nor a deck folder*'
    }
}
