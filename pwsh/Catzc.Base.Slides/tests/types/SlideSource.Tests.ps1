Describe 'SlideSource' -Tag 'L0', 'logic', 'ADR-REPO-SLIDES-SLIDEFILE' {
    BeforeAll {
        $script:body = @'
# The widget spins

## Eyebrow

ADR-WIDGET-GADGET-SPIN · Widgets

## Body

A widget spins when its gadget is **wound**. See [the gadget](gadget.md).

A second paragraph.

## Cards

- **Pin** Another trunk pins the widget.
- **Clone** A team clones it.

## Rows

| Process | Where |
| --- | --- |
| Change | The commit |
| Audit | The history |

## Notes

Say it plainly.
'@
        $script:source = [Catzc.Base.Slides.SlideSource]::Parse($script:body)
    }

    It 'takes the level-one heading as the title' {
        $source.Title | Should -Be 'The widget spins'
        $source.Errors.Count | Should -Be 0
    }

    It 'takes each level-two heading as a field, lowercased' {
        @($source.Fields.Keys) | Sort-Object | Should -Be @('body', 'cards', 'eyebrow', 'notes', 'rows')
    }

    It 'splits paragraphs on blank lines and strips emphasis and links to plain text' {
        $body = $source.Fields['body']
        $body.Items.Count | Should -Be 2
        $body.Items[0].Text | Should -Be 'A widget spins when its gadget is wound. See the gadget.'
        $body.Items[0].Lead | Should -BeNullOrEmpty
        $body.IsList | Should -BeFalse
    }

    It 'reads a list item with a bold lead as lead and text' {
        $cards = $source.Fields['cards']
        $cards.IsList | Should -BeTrue
        $cards.Items.Count | Should -Be 2
        $cards.Items[0].Lead | Should -Be 'Pin'
        $cards.Items[0].Text | Should -Be 'Another trunk pins the widget.'
        $cards.Items[1].Lead | Should -Be 'Clone'
    }

    It 'reads a markdown table as rows, skipping the separator' {
        $rows = $source.Fields['rows']
        $rows.IsTable | Should -BeTrue
        $rows.Rows.Count | Should -Be 3
        @($rows.Rows[0]) | Should -Be @('Process', 'Where')
        @($rows.Rows[2]) | Should -Be @('Audit', 'The history')
        $rows.ItemCount | Should -Be 2
    }

    It 'counts words over every text of a field' {
        $source.Fields['cards'].WordCount() | Should -Be 11
        [Catzc.Base.Slides.SlideSource]::WordCount('  one two   three ') | Should -Be 3
        [Catzc.Base.Slides.SlideSource]::WordCount('') | Should -Be 0
    }

    It 'reports a missing title, a second title, a repeated field and text outside a field' {
        $errors = ([Catzc.Base.Slides.SlideSource]::Parse("stray`n`n# One`n`n# Two`n`n## Body`n`na`n`n## Body`n`nb")).Errors
        $errors | Should -Contain "text outside a field: 'stray'"
        $errors | Should -Contain 'a slide has one level-one heading, its title; a second one was found'
        $errors | Should -Contain "the field 'body' appears twice"
        ([Catzc.Base.Slides.SlideSource]::Parse("## Body`n`na")).Errors | Should -Contain 'a slide has a level-one heading, its title; none was found'
    }

    It 'joins an indented continuation line to the list item above it, as a formatter wraps a long item' {
        $wrapped = [Catzc.Base.Slides.SlideSource]::Parse("# T`n`n## Cards`n`n- **Pin** Another trunk pins the widget and`n  controls when it changes.`n- **Clone** A team clones it.")
        $wrapped.Fields['cards'].Items.Count | Should -Be 2
        $wrapped.Fields['cards'].Items[0].Text | Should -Be 'Another trunk pins the widget and controls when it changes.'
        $wrapped.Fields['cards'].Items[1].Lead | Should -Be 'Clone'
    }

    It 'reads a Windows-ended text the same as a Unix-ended one' {
        $windows = [Catzc.Base.Slides.SlideSource]::Parse($script:body.Replace("`n", "`r`n"))
        $windows.Fields['body'].Items.Count | Should -Be 2
        $windows.Title | Should -Be $source.Title
    }
}
