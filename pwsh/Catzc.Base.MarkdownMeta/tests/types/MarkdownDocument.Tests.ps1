Describe 'MarkdownDocument' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-HEADPOLICY' {
    BeforeAll {
        $script:withMeta = "---`nname: widget`ncatzc:`n  immutable:`n    kind: gadget`nother: 1`n---`n# docs/widget.md`n`nbody text`n"
        $script:plain = "# docs/widget.md`n`nbody text`n"
    }

    It 'splits front matter from the body and finds the meta block' {
        $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:withMeta)
        $doc.HasFrontMatter | Should -BeTrue
        $doc.HasMetaBlock | Should -BeTrue
        $doc.MetaBlock | Should -Be @('catzc:', '  immutable:', '    kind: gadget')
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

    Context 'a block nested under another tool''s key' {
        BeforeAll {
            $script:nested = "---`nname: widget`nmetadata:`n  other: 1`n  catzc:`n    immutable:`n      kind: gadget`n    config:`n      floor: low`n  last: 2`ncatzc:`n  immutable:`n    kind: decoy`n---`nbody`n"
            $script:block = [string[]] @('catzc:', '  immutable:', '    kind: widget')
        }

        It 'finds the block at its key path and returns its lines without the nesting indent' {
            $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:nested, 'metadata.catzc')
            $doc.Key | Should -Be 'metadata.catzc'
            $doc.HasMetaBlock | Should -BeTrue
            $doc.CanHoldMetaBlock | Should -BeTrue
            $doc.MetaBlock | Should -Be @('catzc:', '  immutable:', '    kind: gadget', '  config:', '    floor: low')
            $doc.OtherFrontMatter | Should -Be @('name: widget', 'metadata:', '  other: 1', '  last: 2', 'catzc:', '  immutable:', '    kind: decoy')
            $doc.ToText() | Should -BeExactly $script:nested
        }

        It 'replaces the block in place and leaves the parent''s other keys and a top-level catzc alone' {
            $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:nested, 'metadata.catzc')
            $doc.WithMetaBlock($script:block) |
                Should -BeExactly "---`nname: widget`nmetadata:`n  other: 1`n  catzc:`n    immutable:`n      kind: widget`n  last: 2`ncatzc:`n  immutable:`n    kind: decoy`n---`nbody`n"
            $doc.WithMetaBlock([string[]] @()) |
                Should -BeExactly "---`nname: widget`nmetadata:`n  other: 1`n  last: 2`ncatzc:`n  immutable:`n    kind: decoy`n---`nbody`n"
        }

        It 'appends the block below the parent''s last child, at the children''s indent' {
            $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse("---`nname: widget`nmetadata:`n    other: 1`n`ntools: Read`n---`nbody`n", 'metadata.catzc')
            $doc.HasMetaBlock | Should -BeFalse
            $doc.WithMetaBlock($script:block) |
                Should -BeExactly "---`nname: widget`nmetadata:`n    other: 1`n    catzc:`n      immutable:`n        kind: widget`n`ntools: Read`n---`nbody`n"
        }

        It 'writes the parent keys it does not find, at the end of the front matter or above a body with none' {
            $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse("---`nname: widget`nmetadata:`n---`nbody`n", 'metadata.catzc')
            $doc.WithMetaBlock($script:block) | Should -BeExactly "---`nname: widget`nmetadata:`n  catzc:`n    immutable:`n      kind: widget`n---`nbody`n"
            $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse("---`nname: widget`n---`nbody`n", 'a.b.catzc')
            $doc.WithMetaBlock($script:block) | Should -BeExactly "---`nname: widget`na:`n  b:`n    catzc:`n      immutable:`n        kind: widget`n---`nbody`n"
            $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse("body`n", 'metadata.catzc')
            $doc.WithMetaBlock($script:block) | Should -BeExactly "---`nmetadata:`n  catzc:`n    immutable:`n      kind: widget`n---`n`nbody`n"
        }

        It 'cannot nest under a parent that holds a flow mapping or a scalar, and says which key' {
            $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse("---`nname: widget`nmetadata: { catzc: { floor: low } }`n---`nbody`n", 'metadata.catzc')
            $doc.HasMetaBlock | Should -BeFalse
            $doc.CanHoldMetaBlock | Should -BeFalse
            { $doc.WithMetaBlock($script:block) } | Should -Throw "*'metadata' holds a flow or scalar value*metadata.catzc*"
            $doc.WithMetaBlock([string[]] @()) | Should -BeExactly "---`nname: widget`nmetadata: { catzc: { floor: low } }`n---`nbody`n"
        }

        It 'reads a key path as dotted plain keys that end in catzc' {
            [Catzc.Base.MarkdownMeta.MarkdownDocument]::IsKeyPath('metadata.catzc') | Should -BeTrue
            [Catzc.Base.MarkdownMeta.MarkdownDocument]::IsKeyPath('catzc') | Should -BeTrue
            foreach ($bad in @('', 'metadata', 'metadata.', '.catzc', 'meta data.catzc', 'a:b.catzc')) {
                [Catzc.Base.MarkdownMeta.MarkdownDocument]::IsKeyPath($bad) | Should -BeFalse -Because "'$bad' is no key path"
            }
            { [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse('body', 'metadata') } | Should -Throw "*ending in 'catzc'*"
        }
    }

    It 'reads an unchanged document back byte for byte' -ForEach @(
        @{ Text = "---`nname: widget`ncatzc:`n  immutable:`n    kind: gadget`n---`nbody`n" }
        @{ Text = "---`r`nname: widget`r`n---`r`nbody`r`n" }
        @{ Text = ("--- `n" + "name: widget`n...`nbody") }
        @{ Text = "---`nname: widget`n---" }
        @{ Text = "no front matter`n" }
        @{ Text = '' }
    ) {
        [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($Text).ToText() | Should -BeExactly $Text
    }

    It 'replaces the meta block and keeps every other byte' {
        $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:withMeta)
        $doc.WithMetaBlock([string[]] @('catzc:', '  immutable:', '    kind: widget')) |
            Should -BeExactly "---`nname: widget`ncatzc:`n  immutable:`n    kind: widget`nother: 1`n---`n# docs/widget.md`n`nbody text`n"
    }

    It 'appends a meta block to existing front matter that has none' {
        $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse("---`nname: widget`n---`nbody`n")
        $doc.WithMetaBlock([string[]] @('catzc:', '  immutable:', '    kind: gadget')) |
            Should -BeExactly "---`nname: widget`ncatzc:`n  immutable:`n    kind: gadget`n---`nbody`n"
    }

    It 'creates front matter above a body that has none' {
        $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:plain)
        $doc.WithMetaBlock([string[]] @('catzc:', '  immutable:', '    kind: gadget')) |
            Should -BeExactly "---`ncatzc:`n  immutable:`n    kind: gadget`n---`n`n# docs/widget.md`n`nbody text`n"
    }

    It 'removes the meta block, and the front matter when nothing else is left' {
        $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:withMeta)
        $doc.WithMetaBlock([string[]] @()) | Should -BeExactly "---`nname: widget`nother: 1`n---`n# docs/widget.md`n`nbody text`n"
        $only = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse("---`ncatzc:`n  immutable:`n    kind: gadget`n---`nbody`n")
        $only.WithMetaBlock([string[]] @()) | Should -BeExactly "body`n"
    }

    It 'keeps CRLF line endings when it writes' {
        $doc = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse("---`r`nname: widget`r`n---`r`nbody`r`n")
        $doc.WithMetaBlock([string[]] @('catzc:', '  immutable:', '    kind: gadget')) |
            Should -BeExactly "---`r`nname: widget`r`ncatzc:`r`n  immutable:`r`n    kind: gadget`r`n---`r`nbody`r`n"
    }

    It 'hashes the body only, so front matter and line endings never change it' {
        $a = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:withMeta).BodyHash()
        $a | Should -Match '^[0-9a-f]{12}$'
        [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:plain).BodyHash() | Should -BeExactly $a
        [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:plain.Replace("`n", "`r`n")).BodyHash() | Should -BeExactly $a
        [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:plain + 'more').BodyHash() | Should -Not -BeExactly $a
        [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf($script:plain) | Should -BeExactly $a
        [Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf("`n`n" + $script:plain.Replace("`n", "`r`n")) | Should -BeExactly $a
    }

    It 'does not count the blank line after written front matter, so a second imprint records the same hash' {
        $first = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($script:plain)
        $written = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($first.WithMetaBlock([string[]] @('catzc:', '  immutable:', '    kind: gadget')))
        $written.Body | Should -BeExactly "`n$($script:plain)"
        $written.BodyHash() | Should -BeExactly $first.BodyHash()
    }
}
