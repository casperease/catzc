Describe 'Get-MarkdownListItem' -Tag 'L0', 'logic' {
    It 'yields each item with its continuation lines joined, and the line it starts on' {
        $items = @(Get-MarkdownListItem @(
                '# Widgets'
                ''
                '- [ ] spin the widget, a long item the formatter wrapped'
                '      onto a second line (check: it spins).'
                '1. [ ] turn the gadget'
                '   Check: it turns.'
                '- a plain item'
                ''
                'Prose that ends the list.'
            ))
        $items.Count | Should -Be 3
        $items[0].LineNumber | Should -Be 3
        $items[0].Text |
            Should -BeExactly '- [ ] spin the widget, a long item the formatter wrapped onto a second line (check: it spins).'
        $items[0].First | Should -BeExactly '- [ ] spin the widget, a long item the formatter wrapped'
        $items[1].LineNumber | Should -Be 5
        $items[1].Text | Should -BeExactly '1. [ ] turn the gadget Check: it turns.'
        $items[2].Text | Should -BeExactly '- a plain item'
    }

    It 'ends an item at an unindented line, and starts a nested item as its own' {
        $items = @(Get-MarkdownListItem @(
                '- widget'
                '  - gadget'
                'sprocket'
                '  stray indented prose'
            ))
        @($items | ForEach-Object Text) | Should -Be @('- widget', '  - gadget')
    }

    It 'yields nothing for no lines and for prose without a list' {
        @(Get-MarkdownListItem @()) | Should -HaveCount 0
        @(Get-MarkdownListItem @('Just a widget.', '')) | Should -HaveCount 0
    }
}
