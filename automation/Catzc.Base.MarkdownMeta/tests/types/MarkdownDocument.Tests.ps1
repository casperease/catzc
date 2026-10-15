Describe 'MarkdownDocument' -Tag 'L0', 'logic', 'ADR-REPO-MDMETA#1' {
    BeforeAll {
        $script:withMeta = "---`nname: widget`ncatzc:`n  derived:`n    kind: gadget`nother: 1`n---`n# docs/widget.md`n`nbody text`n"
        $script:plain = "# docs/widget.md`n`nbody text`n"
    }

    It 'splits front matter from the body and finds the meta block' {
        $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:withMeta)
        $doc.HasFrontMatter | Should -BeTrue
        $doc.HasMetaBlock | Should -BeTrue
        $doc.MetaBlock | Should -Be @('catzc:', '  derived:', '    kind: gadget')
        $doc.Body | Should -BeExactly "# docs/widget.md`n`nbody text`n"
    }

    It 'treats a file with no front matter as all body' {
        $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:plain)
        $doc.HasFrontMatter | Should -BeFalse
        $doc.HasMetaBlock | Should -BeFalse
        $doc.Body | Should -BeExactly $script:plain
    }

    It 'does not read an unclosed fence as front matter' {
        $text = "---`nname: widget`n# docs/widget.md`n"
        $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($text)
        $doc.HasFrontMatter | Should -BeFalse
        $doc.Body | Should -BeExactly $text
    }

    It 'ignores a nested or indented catzc key' {
        $text = "---`nname: widget`nother:`n  catzc:`n    x: 1`n---`nbody`n"
        [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($text).HasMetaBlock | Should -BeFalse
    }

    It 'reads an unchanged document back byte for byte' -ForEach @(
        @{ Text = "---`nname: widget`ncatzc:`n  derived:`n    kind: gadget`n---`nbody`n" }
        @{ Text = "---`r`nname: widget`r`n---`r`nbody`r`n" }
        @{ Text = "--- `nname: widget`n...`nbody" }
        @{ Text = "---`nname: widget`n---" }
        @{ Text = "no front matter`n" }
        @{ Text = '' }
    ) {
        [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($Text).ToText() | Should -BeExactly $Text
    }

    It 'replaces the meta block and keeps every other byte' {
        $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:withMeta)
        $doc.WithMetaBlock([string[]] @('catzc:', '  derived:', '    kind: widget')) |
            Should -BeExactly "---`nname: widget`ncatzc:`n  derived:`n    kind: widget`nother: 1`n---`n# docs/widget.md`n`nbody text`n"
    }

    It 'appends a meta block to existing front matter that has none' {
        $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse("---`nname: widget`n---`nbody`n")
        $doc.WithMetaBlock([string[]] @('catzc:', '  derived:', '    kind: gadget')) |
            Should -BeExactly "---`nname: widget`ncatzc:`n  derived:`n    kind: gadget`n---`nbody`n"
    }

    It 'creates front matter above a body that has none' {
        $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:plain)
        $doc.WithMetaBlock([string[]] @('catzc:', '  derived:', '    kind: gadget')) |
            Should -BeExactly "---`ncatzc:`n  derived:`n    kind: gadget`n---`n`n# docs/widget.md`n`nbody text`n"
    }

    It 'removes the meta block, and the front matter when nothing else is left' {
        $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:withMeta)
        $doc.WithMetaBlock([string[]] @()) | Should -BeExactly "---`nname: widget`nother: 1`n---`n# docs/widget.md`n`nbody text`n"
        $only = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse("---`ncatzc:`n  derived:`n    kind: gadget`n---`nbody`n")
        $only.WithMetaBlock([string[]] @()) | Should -BeExactly "body`n"
    }

    It 'keeps CRLF line endings when it writes' {
        $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse("---`r`nname: widget`r`n---`r`nbody`r`n")
        $doc.WithMetaBlock([string[]] @('catzc:', '  derived:', '    kind: gadget')) |
            Should -BeExactly "---`r`nname: widget`r`ncatzc:`r`n  derived:`r`n    kind: gadget`r`n---`r`nbody`r`n"
    }

    It 'hashes the body only, so front matter and line endings never change it' {
        $a = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:withMeta).BodyHash()
        $a | Should -Match '^[0-9a-f]{12}$'
        [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:plain).BodyHash() | Should -BeExactly $a
        [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:plain.Replace("`n", "`r`n")).BodyHash() | Should -BeExactly $a
        [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:plain + 'more').BodyHash() | Should -Not -BeExactly $a
    }

    It 'does not count the blank line after written front matter, so a second imprint records the same hash' {
        $first = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:plain)
        $written = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($first.WithMetaBlock([string[]] @('catzc:', '  derived:', '    kind: gadget')))
        $written.Body | Should -BeExactly "`n$($script:plain)"
        $written.BodyHash() | Should -BeExactly $first.BodyHash()
    }
}
