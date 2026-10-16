<#
---
catzc:
  derived:
    path: automation/Catzc.Base.MarkdownMeta/tests/types/MarkdownMetaBlock.Tests.ps1
    folder: tests/types
    name: markdown-meta-block-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.MarkdownMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
    adrs:
      - ADR-REPO-FILEMETA#3
---
#>

Describe 'MarkdownMetaBlock' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3' {
    It 'renders the derived facts in the order given, one fixed form' {
        $facts = [ordered]@{ kind = 'gadget'; body_sha = '3fa91c0d2b7e'; adrs = @('ADR-WIDGET-GADGET#2', 'ADR-WIDGET-GADGET#3'); count = 2; ok = $true }
        [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render($facts, [string[]] @()) | Should -Be @(
            'catzc:'
            '  derived:'
            '    kind: gadget'
            '    body_sha: "3fa91c0d2b7e"'
            '    adrs:'
            '      - ADR-WIDGET-GADGET#2'
            '      - ADR-WIDGET-GADGET#3'
            '    count: 2'
            '    ok: true'
        )
    }

    It 'leaves out a fact with no value, so its absence reads as the empty value' {
        $facts = [ordered]@{ kind = 'gadget'; adrs = [string[]] @(); links = $null; title = '' }
        [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render($facts, [string[]] @()) | Should -Be @('catzc:', '  derived:', '    kind: gadget')
        [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render([ordered]@{ adrs = [string[]] @() }, [string[]] @()).Count | Should -Be 0
    }

    It 'renders a map as indented slots, and leaves out an empty map' {
        $facts = [ordered]@{ kind = 'gadget'; relatives = [ordered]@{ page = 'docs/gadget.md'; test = 'tests/gadget.Tests.ps1' } }
        [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render($facts, [string[]] @()) | Should -Be @(
            'catzc:'
            '  derived:'
            '    kind: gadget'
            '    relatives:'
            '      page: docs/gadget.md'
            '      test: tests/gadget.Tests.ps1'
        )
        [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render([ordered]@{ relatives = [ordered]@{} }, [string[]] @()).Count | Should -Be 0
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
        @{ Text = 'ADR-WIDGET-GADGET#{1,3-5}'; Expected = 'ADR-WIDGET-GADGET#{1,3-5}' }
        @{ Text = 'ADR-WIDGET-GADGET#{}'; Expected = '"ADR-WIDGET-GADGET#{}"' }
        @{ Text = 'ADR-WIDGET-GADGET#{1, 2}'; Expected = '"ADR-WIDGET-GADGET#{1, 2}"' }
        @{ Text = 'widget#{1,2}'; Expected = '"widget#{1,2}"' }
    ) {
        [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Scalar($Text) | Should -BeExactly $Expected
    }

    It 'reads a grouped ADR token back from a rendered list' {
        $lines = [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render([ordered]@{ adrs = [string[]] @('ADR-WIDGET-GADGET#{1,3-5}', 'ADR-WIDGET-LONE#2') }, [string[]] @())
        [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::DerivedList($lines, 'adrs') | Should -Be @('ADR-WIDGET-GADGET#{1,3-5}', 'ADR-WIDGET-LONE#2')
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

    It 'reads the items of one derived list, and nothing for a scalar, a missing key or a config list' {
        $block = [string[]] @('catzc:', '  derived:', '    kind: gadget', '    adrs:', '      - ADR-WIDGET#1', '      - "ADR-GADGET#2"', '    path: x', '  config:', '    adrs:', '      - ADR-OTHER#3')
        [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::DerivedList($block, 'adrs') | Should -Be @('ADR-WIDGET#1', 'ADR-GADGET#2')
        @([Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::DerivedList($block, 'kind')).Count | Should -Be 0
        @([Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::DerivedList($block, 'widgets')).Count | Should -Be 0
        @([Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::DerivedList($null, 'adrs')).Count | Should -Be 0
    }

    It 'renders no block when there are no facts and no config' {
        @([Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render([ordered]@{}, [string[]] @())).Count | Should -Be 0
    }

    It 'rejects an empty key' {
        { [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render([ordered]@{ '' = 'widget' }, [string[]] @()) } | Should -Throw
    }
}
