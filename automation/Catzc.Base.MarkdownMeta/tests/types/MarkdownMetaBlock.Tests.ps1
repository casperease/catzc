Describe 'MarkdownMetaBlock' -Tag 'L0', 'logic', 'ADR-REPO-MDMETA#3' {
    It 'renders the derived facts in the order given, one fixed form' {
        $facts = [ordered]@{ kind = 'gadget'; body_sha = '3fa91c0d2b7e'; adrs = @('ADR-AUTO-BUNDLE#2', 'ADR-AUTO-BUNDLE#3'); count = 2; ok = $true }
        [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render($facts, [string[]] @()) | Should -Be @(
            'catzc:'
            '  derived:'
            '    kind: gadget'
            '    body_sha: "3fa91c0d2b7e"'
            '    adrs:'
            '      - ADR-AUTO-BUNDLE#2'
            '      - ADR-AUTO-BUNDLE#3'
            '    count: 2'
            '    ok: true'
        )
    }

    It 'renders an empty list in flow form' {
        $facts = [ordered]@{ adrs = [string[]] @() }
        [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render($facts, [string[]] @()) | Should -Contain '    adrs: []'
    }

    It 'quotes a string that YAML would read as something else' -ForEach @(
        @{ Text = '3fa91c0d2b7e'; Expected = '"3fa91c0d2b7e"' }
        @{ Text = '12345'; Expected = '"12345"' }
        @{ Text = 'true'; Expected = '"true"' }
        @{ Text = 'No'; Expected = '"No"' }
        @{ Text = ''; Expected = '""' }
        @{ Text = 'a: b'; Expected = '"a: b"' }
        @{ Text = 'say "hi"'; Expected = '"say \"hi\""' }
        @{ Text = "two`nlines"; Expected = '"two\nlines"' }
        @{ Text = 'widget'; Expected = 'widget' }
        @{ Text = 'docs/adr/widget.md'; Expected = 'docs/adr/widget.md' }
    ) {
        [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Scalar($Text) | Should -BeExactly $Expected
    }

    It 'keeps the authored config lines exactly as written' {
        $config = [string[]] @('    gadgets:', '      widget: { gates: [Test-Widget] }')
        [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render([ordered]@{ kind = 'gadget' }, $config) | Should -Be @(
            'catzc:', '  derived:', '    kind: gadget', '  config:', '    gadgets:', '      widget: { gates: [Test-Widget] }'
        )
    }

    It 'reads its own config lines back, so a second render is identical' {
        $config = [string[]] @('    gadgets:', '      widget: { gates: [Test-Widget] }')
        $facts = [ordered]@{ kind = 'gadget'; body_sha = '3fa91c0d2b7e' }
        $first = [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render($facts, $config)
        $back = [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::ConfigLines($first)
        $back | Should -Be $config
        [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render($facts, $back) | Should -Be $first
    }

    It 'finds no config lines when the block has no config part' {
        $block = [string[]] @('catzc:', '  derived:', '    kind: gadget')
        @([Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::ConfigLines($block)).Count | Should -Be 0
    }

    It 'lists the keys at the block''s first level and inside derived' {
        $block = [string[]] @('catzc:', '  derived:', '    kind: gadget', '    "body_sha": x', '    adrs:', '      - ADR-WIDGET#1', '  config:', '    gadgets:', '  other: 2')
        [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::SectionKeys($block) | Should -Be @('derived', 'config', 'other')
        [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::DerivedKeys($block) | Should -Be @('kind', 'body_sha', 'adrs')
    }

    It 'renders no block when there are no facts and no config' {
        @([Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render([ordered]@{}, [string[]] @())).Count | Should -Be 0
    }

    It 'rejects an empty key' {
        { [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render([ordered]@{ '' = 'widget' }, [string[]] @()) } | Should -Throw
    }
}
