<#
---
catzc:
  immutable:
    with_body_sha: "19289b3cadb9"
  edges:
    code: pwsh/Catzc.Base.MarkdownMeta/types/MarkdownMetaBlock.cs
    cites:
      - ADR-REPO-FILEMETA-IMPRINTEDPARTS
      - ADR-REPO-HELP-HELPONCOMMENTPAGE
---
#>

Describe 'MarkdownMetaBlock' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
    BeforeAll {
        $script:none = [string[]] @()
        $script:block = [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]
    }

    It 'renders the place facts, then the edges, in the order given, one fixed form' {
        $immutable = [ordered]@{ with_body_sha = '3fa91c0d2b7e'; kind = 'gadget'; count = 2; ok = $true }
        $edges = [ordered]@{ cites = @('ADR-WIDGET-GADGET-SPIN', 'ADR-WIDGET-GADGET-FOLD'); page = 'docs/gadget.md' }
        $script:block::Render($immutable, $edges, $script:none) | Should -Be @(
            'catzc:'
            '  immutable:'
            '    with_body_sha: "3fa91c0d2b7e"'
            '    kind: gadget'
            '    count: 2'
            '    ok: true'
            '  edges:'
            '    cites:'
            '      - ADR-WIDGET-GADGET-SPIN'
            '      - ADR-WIDGET-GADGET-FOLD'
            '    page: docs/gadget.md'
        )
    }

    It 'leaves out a fact or an edge with no value, so its absence reads as the empty value' {
        $immutable = [ordered]@{ kind = 'gadget'; title = '' }
        $edges = [ordered]@{ cites = [string[]] @(); links = $null }
        $script:block::Render($immutable, $edges, $script:none) | Should -Be @('catzc:', '  immutable:', '    kind: gadget')
        $script:block::Render([ordered]@{}, $edges, $script:none).Count | Should -Be 0
    }

    It 'leaves out the part that has nothing, and keeps the other' {
        $script:block::Render([ordered]@{}, [ordered]@{ links = @('docs/gadget.md') }, $script:none) | Should -Be @(
            'catzc:', '  edges:', '    links:', '      - docs/gadget.md'
        )
    }

    It 'renders a map as indented slots, and leaves out an empty map' {
        $immutable = [ordered]@{ kind = 'gadget'; slots = [ordered]@{ page = 'docs/gadget.md'; test = 'tests/gadget.Tests.ps1' } }
        $script:block::Render($immutable, [ordered]@{}, $script:none) | Should -Be @(
            'catzc:'
            '  immutable:'
            '    kind: gadget'
            '    slots:'
            '      page: docs/gadget.md'
            '      test: tests/gadget.Tests.ps1'
        )
        $script:block::Render([ordered]@{ slots = [ordered]@{} }, [ordered]@{}, $script:none).Count | Should -Be 0
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
        @{ Text = 'docs/drs/widget.md'; Expected = 'docs/drs/widget.md' }
        @{ Text = 'ADR-WIDGET-GADGET-RE01'; Expected = 'ADR-WIDGET-GADGET-RE01' }
        @{ Text = 'ADR-WIDGET-GADGET#{1,3-5}'; Expected = '"ADR-WIDGET-GADGET#{1,3-5}"' }
        @{ Text = 'ADR-WIDGET-GADGET#{1, 2}'; Expected = '"ADR-WIDGET-GADGET#{1, 2}"' }
        @{ Text = 'widget#{1,2}'; Expected = '"widget#{1,2}"' }
    ) {
        [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Scalar($Text) | Should -BeExactly $Expected
    }

    It 'reads ADR and rule codes back from a rendered list edge' {
        $lines = $script:block::Render([ordered]@{}, [ordered]@{ cites = [string[]] @('ADR-WIDGET-GADGET', 'ADR-WIDGET-LONE-RE02') }, $script:none)
        $script:block::EdgeList($lines, 'cites') | Should -Be @('ADR-WIDGET-GADGET', 'ADR-WIDGET-LONE-RE02')
    }

    It 'keeps the authored config lines exactly as written' {
        $config = [string[]] @('    gadgets:', '      widget: { gates: [Test-Widget] }')
        $script:block::Render([ordered]@{ kind = 'gadget' }, [ordered]@{}, $config) | Should -Be @(
            'catzc:', '  immutable:', '    kind: gadget', '  config:', '    gadgets:', '      widget: { gates: [Test-Widget] }'
        )
    }

    It 'reads its own config lines back, so a second render is identical' {
        $config = [string[]] @('    gadgets:', '      widget: { gates: [Test-Widget] }')
        $immutable = [ordered]@{ with_body_sha = '3fa91c0d2b7e'; kind = 'gadget' }
        $edges = [ordered]@{ links = @('docs/gadget.md') }
        $first = $script:block::Render($immutable, $edges, $config)
        $back = $script:block::ConfigLines($first)
        $back | Should -Be $config
        $script:block::Render($immutable, $edges, $back) | Should -Be $first
    }

    It 'finds no config lines when the block has no config part' {
        $lines = [string[]] @('catzc:', '  immutable:', '    kind: gadget')
        @($script:block::ConfigLines($lines)).Count | Should -Be 0
    }

    It 'lists the keys at the block''s first level, inside immutable and the names of the edges' {
        $lines = [string[]] @('catzc:', '  immutable:', '    kind: gadget', '    "with_body_sha": x', '  edges:', '    cites:', '      - ADR-WIDGET-TURN', '    page: docs/gadget.md', '  config:', '    gadgets:', '  other: 2')
        $script:block::SectionKeys($lines) | Should -Be @('immutable', 'edges', 'config', 'other')
        $script:block::ImmutableKeys($lines) | Should -Be @('kind', 'with_body_sha')
        $script:block::EdgeKeys($lines) | Should -Be @('cites', 'page')
    }

    It 'reads the items of one list edge, and nothing for a scalar edge, a missing edge, a place fact or a config list' {
        $lines = [string[]] @('catzc:', '  immutable:', '    cites:', '      - ADR-PLACE-DROP', '  edges:', '    cites:', '      - ADR-WIDGET-TURN', '      - "ADR-GADGET-SPIN"', '    page: x', '  config:', '    cites:', '      - ADR-OTHER-FOLD')
        $script:block::EdgeList($lines, 'cites') | Should -Be @('ADR-WIDGET-TURN', 'ADR-GADGET-SPIN')
        @($script:block::EdgeList($lines, 'page')).Count | Should -Be 0
        @($script:block::EdgeList($lines, 'widgets')).Count | Should -Be 0
        @($script:block::EdgeList($null, 'cites')).Count | Should -Be 0
    }

    It 'renders no block when there are no facts, no edges and no config' {
        @($script:block::Render([ordered]@{}, [ordered]@{}, $script:none)).Count | Should -Be 0
    }

    It 'rejects an empty key' {
        { $script:block::Render([ordered]@{ '' = 'widget' }, [ordered]@{}, $script:none) } | Should -Throw
        { $script:block::Render([ordered]@{}, [ordered]@{ '' = 'widget' }, $script:none) } | Should -Throw
    }

    It 'drops the config part and keeps the facts as written, and a block with nothing else is no block' -Tag 'ADR-REPO-HELP-HELPONCOMMENTPAGE' {
        $lines = [string[]] @('catzc:', '  immutable:', '    path: widget.ps1', '  config:', '    synopsis: Gets.', '    parameters:', '      Name: N.')
        $script:block::WithoutConfig($lines) | Should -Be @('catzc:', '  immutable:', '    path: widget.ps1')
        $script:block::WithoutConfig([string[]] @('catzc:', '  config:', '    synopsis: Gets.')).Count | Should -Be 0
        $script:block::WithoutConfig([string[]] @('catzc:', '  edges:', '    page: p.md')) | Should -Be @('catzc:', '  edges:', '    page: p.md')
    }
}
