<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/types/CommentFormatter.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-IDEM#1
      - ADR-PRIN-CONFIG#1
      - ADR-PRIN-ONELIVE#1
      - ADR-REPO-COMMENTS#5
      - ADR-REPO-LINK#9
---
#>

# CommentFormatter keeps a comment residue in its one-liner shape — one insight line, then the citations and the docs...
# [comment:1](/docs/references/automation/catzc-base-qualitygates/tests/types/CommentFormatter.Tests.ps1.md#comment1)
Describe 'CommentFormatter' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:config = [Catzc.Base.QualityGates.CommentsConfig]::new(@{})
        $script:page = 'docs/references/automation/catzc-widget/Get-Widget.ps1.md'
        $script:link = "[comment:1](/$page#comment1)"
        $script:format = {
            param([string] $Text, [string] $PageText = $null, [string] $Extension = '.ps1', [string] $Language = 'powershell')
            [Catzc.Base.QualityGates.CommentFormatter]::Format($Text, $Extension, $Language, 'automation/Catzc.Widget/Get-Widget.ps1',
                $PageText, $script:config, 80)
        }
        $script:snippet = {
            param([string[]] $Residue)
            (@('function Get-Widget {') + @($Residue | ForEach-Object { "    # $_" }) + @('    Get-Gadget', '}', '')) -join "`n"
        }
        $script:pageText = @(
            "# $page"
            ''
            '## comment:1'
            ''
            'Above `Get-Gadget`.'
            ''
            '```text'
            'Sorted first, so the gadget order is stable'
            'across runs. The cache key never changes.'
            '```'
            ''
        ) -join "`n"
    }

    It 'leaves a residue in shape alone' -Tag 'ADR-AUTO-IDEM#1' {
        $result = & $format (& $snippet 'Sorted first, so the gadget order is stable.', $link)
        $result.Changed | Should -BeFalse
        $result.Findings.Count | Should -Be 0
        "$result" | Should -Be 'automation/Catzc.Widget/Get-Widget.ps1: 0 fixed, 0 need a person'
    }

    It 'cuts an overlong insight at a word, and a second run changes nothing' -Tag 'ADR-REPO-COMMENTS#5', 'ADR-AUTO-IDEM#1' {
        $long = 'Sorted first so the gadget order is stable across every run and the cache key of the widget never changes'
        $result = & $format (& $snippet $long, $link)
        $result.Changed | Should -BeTrue
        $result.Findings.Count | Should -Be 1
        $result.Findings[0].Kind | Should -Be ([Catzc.Base.QualityGates.CommentFindingKind]::Overlong)
        $result.Findings[0].Line | Should -Be 2
        $result.Findings[0].IsFixable | Should -BeTrue
        $lines = $result.Text -split "`n"
        $lines[1].Length | Should -BeLessOrEqual 80
        $lines[1] | Should -BeLike '    # Sorted first so the gadget order*...'
        $lines[2] | Should -Be "    # $link"
        (& $format $result.Text).Changed | Should -BeFalse
    }

    It 'drops a link and a citation from the insight line, and the citations before the docs link' -Tag 'ADR-REPO-COMMENTS#5' {
        $insight = 'Sorted first (ADR-WIDGET#2, [docs](/docs/w.md)), so the order is stable.'
        $result = & $format (& $snippet $insight, "ADR-GADGET#1 $link")
        @($result.Findings | ForEach-Object { "$($_.Kind)" }) | Should -Be @('LinkInInsight', 'CitationInResidue')
        $lines = $result.Text -split "`n"
        $lines[1] | Should -Be '    # Sorted first, so the order is stable.'
        $lines[2] | Should -Be "    # $link"
        (& $format $result.Text).Changed | Should -BeFalse
    }

    It 'removes the citation lines between the insight and the docs link' -Tag 'ADR-REPO-COMMENTS#5', 'ADR-AUTO-IDEM#1' {
        $result = & $format (& $snippet 'Sorted first, so the order is stable.', '[ADR-WIDGET#2](/docs/adr/w.md#rule-adr-widget2),', '[ADR-GADGET](/docs/adr/g.md)', $link)
        @($result.Findings | ForEach-Object { "$($_.Kind)" }) | Should -Be @('CitationInResidue')
        $result.Findings[0].IsFixable | Should -BeTrue
        $lines = $result.Text -split "`n"
        $lines[1] | Should -Be '    # Sorted first, so the order is stable.'
        $lines[2] | Should -Be "    # $link"
        $lines[3] | Should -Be '    Get-Gadget'
        (& $format $result.Text).Changed | Should -BeFalse
    }

    It 'gives a residue without an insight line the first sentence of its own section' -Tag 'ADR-PRIN-ONELIVE#1' {
        $result = & $format (& $snippet $link) $pageText
        $result.Findings.Count | Should -Be 1
        $result.Findings[0].Kind | Should -Be ([Catzc.Base.QualityGates.CommentFindingKind]::Empty)
        $lines = $result.Text -split "`n"
        $lines[1] | Should -Be '    # Sorted first, so the gadget order is stable across runs.'
        $lines[2] | Should -Be "    # $link"
        $lines[3] | Should -Be '    Get-Gadget'
    }

    It 'reports an obvious insight, prose on the link line, a missing section and a long comment, and changes nothing' -Tag 'ADR-REPO-COMMENTS#5', 'ADR-PRIN-CONFIG#1' {
        $text = (@(
                'function Get-Widget {'
                '    # This function sorts the widgets.'
                "    # $link and a note"
                '    Get-Gadget'
                "    # [comment:2](/$page#comment2)"
                '    $widgets'
                '    # A gadget comment that still'
                '    # spans two lines.'
                '    $gadgets'
                '}'
                ''
            ) -join "`n")
        $result = & $format $text $pageText
        $result.Changed | Should -BeFalse
        @($result.Findings | ForEach-Object { "$($_.Kind)" }) | Should -Be @('Obvious', 'ProseOnLinkLine', 'MissingSection', 'LongComment')
        @($result.Findings | ForEach-Object Line) | Should -Be @(2, 3, 5, 7)
        $result.Findings | ForEach-Object { $_.IsFixable | Should -BeFalse }
        "$($result.Findings[3])" | Should -Match '^automation/Catzc\.Widget/Get-Widget\.ps1:7 \[LongComment\] .*run Export-Comments$'
        $result.UnfixableCount | Should -Be 4
    }

    It 'keeps a CRLF file''s line endings and the untouched lines byte for byte' -Tag 'ADR-PRIN-ONELIVE#1' {
        $long = 'Sorted first so the gadget order is stable across every run and the cache key of the widget never changes'
        $crlf = "`r`n"
        $text = @('# The gadget registry.', 'widgets:', "  # $long", "  # $link", '  - gadget', '') -join $crlf
        $result = & $format $text $null '.yml' 'yaml'
        $result.Changed | Should -BeTrue
        $expected = @('# The gadget registry.', 'widgets:', '  # Sorted first so the gadget order*...', "  # $([WildcardPattern]::Escape($link))", '  - gadget', '') -join $crlf
        $result.Text | Should -BeLike $expected
        $result.Text.Contains("`n`n") | Should -BeFalse
    }

    Context 'a help section whose page section names it' {
        BeforeAll {
            $script:helpPage = @(
                "# $page", '', '## comment:1', '', 'Section `.DESCRIPTION` of the comment-based help.', '', '```text',
                'Reads the widget from the gadget store first,', 'because the store is the one living copy.', '```', ''
            ) -join "`n"
            $script:helpText = {
                param([string[]] $Description)
                (@('<#', '.SYNOPSIS', '    Gets a widget.', '.DESCRIPTION') + @($Description | ForEach-Object { "    $_" }) +
                    @('#>', 'function Get-Widget { }', '')) -join "`n"
            }
        }

        It 'drops the docs link, keeps the insight line, and a second run changes nothing' -Tag 'ADR-REPO-LINK#9', 'ADR-AUTO-IDEM#1' {
            $result = & $format (& $helpText 'Reads the widget from the gadget store first.', $link) $helpPage
            $result.Changed | Should -BeTrue
            @($result.Findings | ForEach-Object { "$($_.Kind)" }) | Should -Be @('LinkInHelp')
            $result.Text | Should -BeExactly (& $helpText 'Reads the widget from the gadget store first.')
            $again = & $format $result.Text $helpPage
            $again.Changed | Should -BeFalse
            $again.Findings.Count | Should -Be 0
        }

        It 'keeps the docs link when the section holds more than the residue: another prose line, or a second residue' -Tag 'ADR-REPO-LINK#9' {
            $extra = & $format (& $helpText 'A widget line an author wrote.', 'Reads the widget from the gadget store first.', $link) $helpPage
            $extra.Changed | Should -BeFalse
            $second = "[comment:2](/$page#comment2)"
            $two = & $format (& $helpText 'Reads the widget from the gadget store first.', $link, 'The gadget order is stable.', $second) $helpPage
            $two.Changed | Should -BeFalse
        }

        It 'keeps the docs link when the page does not name the section' -Tag 'ADR-REPO-LINK#9' {
            $result = & $format (& $helpText 'Reads the widget from the gadget store first.', $link) $pageText
            @($result.Findings | Where-Object { "$($_.Kind)" -eq 'LinkInHelp' }).Count | Should -Be 0
            $result.Changed | Should -BeFalse -Because 'the link is the only pairing the residue has'
        }
    }
}
