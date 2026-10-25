Describe 'SlidePattern' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES-PATTERN', 'ADR-REPO-SLIDES-FAILFORWARDRENDER' {
    BeforeAll {
        $script:html = @'
<!--
---
catzc:
  immutable:
    kind: slides-kit
---
-->
<section id="{{@id}}" data-transition="fade" style="background:{{@token.bg}};font-family:{{@face.text}}">
    <p style="color:{{@token.accent}}">
        {{eyebrow}}
    </p>
    <h2 style="font-size:{{@scale.h2}}px">{{title}}</h2>
    <div data-field="body" data-max="2" data-max-words="12">
        <p data-item>{{item}}</p>
    </div>
    <div data-field="cards" data-optional data-max="2">
        <div data-item><h3>{{item.lead}}</h3><p>{{item}}</p></div>
        <x-shape data-separator kind="arrow-down"></x-shape>
    </div>
    <table data-field="rows" data-optional data-max="3">
        <tr data-item="header"><th>{{cell}}</th></tr>
        <tr data-item><td>{{cell}}</td></tr>
    </table>
    <p style="position:absolute">{{footer?}}</p>
    <p>{{@page}}</p>
    <aside>{{notes?}}</aside>
</section>
'@
        $script:pattern = [Catzc.Base.Slides.SlidePattern]::Load('widget', $script:html)
        $script:kit = [System.Func[string, string]] {
            param([string] $reference)
            switch ($reference) {
                'token.bg' {
                    '#101010'
                }
                'token.accent' {
                    '#ABCDEF'
                }
                'face.text' {
                    'Arial, sans-serif'
                }
                'scale.h2' {
                    '72'
                }
                default {
                    throw [System.Collections.Generic.KeyNotFoundException]::new("the kit declares no value '$reference'")
                }
            }
        }
        $script:render = {
            param([string] $Body, [int] $Page = 3)
            $source = [Catzc.Base.Slides.SlideSource]::Parse($Body)
            $script:pattern.Render($source, 'docs/gadget.slide.md', $script:kit, 'gadget', $Page)
        }
        $script:good = "# The widget spins`n`n## Eyebrow`n`nADR-WIDGET-GADGET-SPIN`n`n## Body`n`nA widget spins when wound.`n`n## Notes`n`nSay it."
    }

    It 'reads the fields of a pattern: inline ones from placeholders, block ones from data-field, each with its capacity' {
        $fields = @($pattern.Fields | ForEach-Object ToString)
        $fields | Should -Contain 'body (Block)'
        $fields | Should -Contain 'cards? (Block)'
        $fields | Should -Contain 'rows? (Table)'
        $fields | Should -Contain 'eyebrow (Inline)'
        $fields | Should -Contain 'title (Inline)'
        $fields | Should -Contain 'footer? (Inline)'
        $fields | Should -Contain 'notes? (Inline)'
        $pattern.Field('body').Max | Should -Be 2
        $pattern.Field('body').MaxWords | Should -Be 12
        $pattern.Field('cards').Required | Should -BeFalse
    }

    It 'fills kit values, the id and the page, and strips the comment head' {
        $result = & $render $good
        $result.Faults.Count | Should -Be 0
        $result.Html | Should -Match '^<section id="gadget" data-transition="fade" style="background:#101010;font-family:Arial, sans-serif">'
        $result.Html | Should -Not -Match 'catzc'
        $result.Html | Should -Match '<p>3</p>'
    }

    It 'fills inline fields trimmed, and a block field once per paragraph without the template attributes' {
        $html = (& $render "$good`n`nA second paragraph.".Replace("## Notes`n`nSay it.`n`nA second paragraph.", "A second paragraph.`n`n## Notes`n`nSay it.")).Html
        $html | Should -Match '<p style="color:#ABCDEF">ADR-WIDGET-GADGET-SPIN</p>'
        $html | Should -Match '<h2 style="font-size:72px">The widget spins</h2>'
        $html | Should -Match '<div><p>A widget spins when wound.</p><p>A second paragraph.</p></div>'
        $html | Should -Not -Match 'data-field|data-item|data-max'
    }

    It 'removes the element of an absent optional field and keeps notes as the last child' {
        $html = (& $render $good).Html
        $html | Should -Not -Match 'position:absolute'
        $html | Should -Match '<aside>Say it.</aside></section>$'
        $html | Should -Not -Match '<table'
    }

    It 'fills a card template with lead and text and places the separator between items' {
        $html = (& $render "$good`n`n## Cards`n`n- **Pin** Another trunk pins it.`n- **Clone** A team clones it.").Html
        $html | Should -Match '<div><h3>Pin</h3><p>Another trunk pins it.</p></div><x-shape kind="arrow-down"></x-shape><div><h3>Clone</h3><p>A team clones it.</p></div>'
    }

    It 'fills a table from a markdown table, the header row from its template' {
        $html = (& $render "$good`n`n## Rows`n`n| Process | Where |`n| --- | --- |`n| Change | The commit |").Html
        $html | Should -Match '<table><tr><th>Process</th><th>Where</th></tr><tr><td>Change</td><td>The commit</td></tr></table>'
    }

    It 'reports a missing required field, an unknown field, and a kit value the kit does not declare' -Tag 'PDR-POKAYOKE-DETECTEARLIEST' {
        $faults = @((& $render "# T`n`n## Eyebrow`n`nE`n`n## Gadget`n`nx").Faults | ForEach-Object ToString)
        $faults | Should -Contain "docs/gadget.slide.md: field 'body': pattern 'widget' requires this field and the slide has none"
        $faults | Should -Contain "docs/gadget.slide.md: field 'gadget': pattern 'widget' does not know this field (it takes: body, cards, rows, eyebrow, title, footer, notes)"
        $broken = [Catzc.Base.Slides.SlidePattern]::Load('broken', '<section style="color:{{@token.gadget}}"><h2>{{title}}</h2></section>')
        $result = $broken.Render([Catzc.Base.Slides.SlideSource]::Parse('# T'), 'p.slide.md', $script:kit, 'p', 1)
        @($result.Faults | ForEach-Object ToString) | Should -Contain "p.slide.md: pattern 'broken': the kit declares no value 'token.gadget'"
    }

    It 'reports a field over its capacity in items or words and still renders every item' -Tag 'ADR-REPO-SLIDES-FAILFORWARDRENDER' {
        $result = & $render "$good`n`nTwo.`n`nThree is one too many words here now.".Replace("## Notes`n`nSay it.`n`nTwo.`n`nThree is one too many words here now.", "Two.`n`nThree is one too many words here now.`n`n## Notes`n`nSay it.")
        $faults = @($result.Faults | ForEach-Object ToString)
        $faults | Should -Contain "docs/gadget.slide.md: field 'body': 3 items; pattern 'widget' holds at most 2"
        ($faults -join "`n") | Should -Match "field 'body': \d+ words; pattern 'widget' holds at most 12"
        $result.Html | Should -Match 'Three is one too many words here now.'
    }

    It 'reports an inline field given more than one line, a card without a lead, and a table field given prose' {
        $faults = @((& $render "$good`n`n## Cards`n`n- No lead here.`n`n## Rows`n`nProse, not a table.".Replace("## Eyebrow`n`nADR-WIDGET-GADGET-SPIN", "## Eyebrow`n`nOne`n`nTwo")).Faults | ForEach-Object ToString)
        $faults | Should -Contain "docs/gadget.slide.md: field 'eyebrow': pattern 'widget' takes one line here; the slide gives 2 items"
        $faults | Should -Contain "docs/gadget.slide.md: field 'cards': item 1 has no bold lead; pattern 'widget' shows one per item"
        $faults | Should -Contain "docs/gadget.slide.md: field 'rows': pattern 'widget' takes a markdown table here, with its first row the header"
    }

    It 'carries the source errors as faults' {
        @((& $render "## Body`n`nx").Faults | ForEach-Object Message) | Should -Contain 'a slide has a level-one heading, its title; none was found'
    }

    It 'refuses a pattern that is not one well-formed section' {
        { [Catzc.Base.Slides.SlidePattern]::Load('gadget', '<div>{{title}}</div>') } | Should -Throw '*must be one <section>, not <div>*'
        { [Catzc.Base.Slides.SlidePattern]::Load('gadget', '<section><p>{{title}}</section>') } | Should -Throw '*not one well-formed section*'
        { [Catzc.Base.Slides.SlidePattern]::Load('gadget', '<!-- only a comment -->') } | Should -Throw '*holds no section*'
    }

    It 'reads the text of a rendered slide without tags, with entities decoded and spaces collapsed' {
        [Catzc.Base.Slides.SlidePattern]::TextOf("<section><p>A &amp; B</p>`n   <h2>C</h2></section>") | Should -Be 'A & B C'
    }

    It 'writes an empty element with a closing tag, as the slide format reads it' {
        (& $render "$good`n`n## Cards`n`n- **A** a`n- **B** b").Html | Should -Match '<x-shape kind="arrow-down"></x-shape>'
    }
}

Describe 'SlideFault' -Tag 'L0', 'logic' {
    It 'prints its path, field and message, leaving out what it was not given' {
        [Catzc.Base.Slides.SlideFault]::new('a.slide.md', 'body', 'too long').ToString() | Should -Be "a.slide.md: field 'body': too long"
        [Catzc.Base.Slides.SlideFault]::new('a.slide.md', '', 'no pattern').ToString() | Should -Be 'a.slide.md: no pattern'
        [Catzc.Base.Slides.SlideFault]::new('', 'body', 'x').ToString() | Should -Be "field 'body': x"
        { [Catzc.Base.Slides.SlideFault]::new('a', 'b', ' ') } | Should -Throw '*carries a message*'
    }
}
