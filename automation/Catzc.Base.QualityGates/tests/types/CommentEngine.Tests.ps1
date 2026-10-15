# CommentEngine moves a file's long comments to its comment page and back, losslessly
# ([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)): what moves is decided by
# comments.yml ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)). Each case
# runs the engine over a short widget/gadget snippet; the proofs are the round trip and the idempotent second run.
Describe 'CommentEngine' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:config = [Catzc.Base.QualityGates.CommentsConfig]::new(@{})
        $script:page = 'docs/references/automation/catzc-widget/Get-Widget.ps1.md'
        $script:export = {
            param([string] $Text, [string] $Extension = '.ps1', [string] $Language = 'powershell', [string] $PageText = $null)
            [Catzc.Base.QualityGates.CommentEngine]::Export($Text, $Extension, $Language, 'automation/Catzc.Widget/Get-Widget.ps1',
                $script:page, $PageText, $script:config, 120)
        }
        $script:helpSource = @(
            '<#'
            '.SYNOPSIS'
            '    Gets a widget.'
            '.DESCRIPTION'
            '    Reads the widget from the gadget store first, because the store is the one'
            '    living copy ([ADR-WIDGET#2](/docs/adr/widget/widget.md#rule-adr-widget2)).'
            ''
            '    A missing widget is created.'
            '.PARAMETER Name'
            '    The widget name.'
            '.EXAMPLE'
            '    Get-Widget -Name gadget'
            '    Get-Widget'
            '#>'
            'function Get-Widget {'
            '    # Sorted first, so the gadget order is stable'
            '    # across runs and the cache key never changes.'
            '    $widgets = Get-Gadget | Sort-Object   # a trailing note stays'
            '    # One line stays.'
            '    $widgets'
            '}'
            ''
        ) -join "`n"
    }

    It 'finds the help sections and line runs with enough prose, not the kept sections, short ones, or trailing comments' -Tag 'ADR-PRIN-CONFIG#1' {
        $blocks = [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($helpSource, '.ps1', 'powershell', $config)
        $blocks.Count | Should -Be 2
        $blocks[0].Kind | Should -Be ([Catzc.Base.QualityGates.CommentBlockKind]::HelpSection)
        $blocks[0].Keyword | Should -Be '.DESCRIPTION'
        $blocks[0].Lines.Count | Should -Be 4
        $blocks[0].Lines[2] | Should -BeExactly ''
        $blocks[1].Kind | Should -Be ([Catzc.Base.QualityGates.CommentBlockKind]::LineRun)
        $blocks[1].Marker | Should -Be '#'
        $blocks[1].NextCodeLine | Should -BeLike '$widgets = Get-Gadget*'
    }

    It 'leaves one insight line and one citation-and-link line per moved block' -Tag 'ADR-PRIN-ONELIVE#1' {
        $result = & $export $helpSource
        $result.MovedCount | Should -Be 2
        $lines = $result.Text -split "`n"
        $lines | Should -Contain '    Reads the widget from the gadget store first, because the store is the one living copy.'
        $lines | Should -Contain "    ADR-WIDGET#2 [comment:1](/$page#comment1)"
        $lines | Should -Contain '    # Sorted first, so the gadget order is stable across runs and the cache key never changes.'
        $lines | Should -Contain "    # [comment:2](/$page#comment2)"
        $lines | Should -Contain '    The widget name.'
        $lines | Should -Contain '    $widgets = Get-Gadget | Sort-Object   # a trailing note stays'
        $result.PageText.StartsWith("# $page`n") | Should -BeTrue
        $section = "## comment:1`n`nSection ``.DESCRIPTION`` of the comment-based help.`n`n" + '```text' + "`nReads the widget from the gadget store first"
        $result.PageText.Contains($section) | Should -BeTrue -Because 'a section names its context and fences the prose, indent stripped'
        $result.PageText.Contains("`n`nA missing widget is created.`n" + '```') | Should -BeTrue -Because 'the blank line inside the comment is kept'
    }

    It 'round-trips: the view of the exported file is the original, byte for byte' -Tag 'ADR-PRIN-ONELIVE#1' {
        $result = & $export $helpSource
        [Catzc.Base.QualityGates.CommentEngine]::View($result.Text, '.ps1', $result.PageText) | Should -BeExactly $helpSource
    }

    It 'is idempotent: a second export moves nothing and changes nothing' -Tag 'ADR-AUTO-IDEM#1' {
        $first = & $export $helpSource
        $second = & $export $first.Text '.ps1' 'powershell' $first.PageText
        $second.Changed | Should -BeFalse
        $second.MovedCount | Should -Be 0
    }

    It 'numbers a new comment after the page''s highest section and keeps the existing sections as written' -Tag 'ADR-PRIN-ONELIVE#1' {
        $first = & $export $helpSource
        $edited = $first.PageText -replace 'A missing widget is created.', 'A missing widget is created on demand.'
        $grown = $first.Text -replace '    # One line stays.', "    # A new gadget note`n    # that spans two lines."
        $second = & $export $grown '.ps1' 'powershell' $edited
        $second.MovedCount | Should -Be 1
        $second.Text.Contains("[comment:3](/$page#comment3)") | Should -BeTrue
        $second.PageText.IndexOf('created on demand.') | Should -BeLessThan $second.PageText.IndexOf('## comment:3')
        [Catzc.Base.QualityGates.CommentEngine]::View($second.Text, '.ps1', $second.PageText).Contains('created on demand.') | Should -BeTrue
    }

    It 'finds every residue with its number, page and insight' -Tag 'ADR-PRIN-ONELIVE#1' {
        $result = & $export $helpSource
        $residues = [Catzc.Base.QualityGates.CommentEngine]::FindResidues($result.Text, '.ps1')
        $residues.Count | Should -Be 2
        $residues[0].Number | Should -Be 1
        $residues[0].Page | Should -Be $page
        $residues[0].Insight | Should -BeLike 'Reads the widget*'
        $residues[1].Marker | Should -Be '#'
        $residues[1].LineCount | Should -Be 2
        [Catzc.Base.QualityGates.CommentEngine]::SectionNumbers($result.PageText) | Should -Be @(1, 2)
    }

    It 'round-trips a YAML header, a CRLF file, and a C# line run with its own marker' -Tag 'ADR-PRIN-ONELIVE#1' {
        $yaml = "# The gadget registry: one entry per widget,`r`n# read once per run.`r`nwidgets:`r`n  - gadget   # inline stays`r`n"
        $yamlResult = & $export $yaml '.yml' 'yaml'
        $yamlResult.MovedCount | Should -Be 1
        $yamlResult.Text.Contains("`r`n# [comment:1]") | Should -BeTrue -Because 'the file keeps its CRLF line endings'
        [Catzc.Base.QualityGates.CommentEngine]::View($yamlResult.Text, '.yml', $yamlResult.PageText) | Should -BeExactly $yaml

        $csharp = "namespace Widget;`n`n/// The gadget cache, keyed by widget,`n/// so a lookup is one hash.`npublic sealed class Gadget { }`n"
        $csResult = & $export $csharp '.cs' 'csharp'
        $csResult.Text | Should -BeLike '*/// The gadget cache, keyed by widget, so a lookup is one hash.*'
        [Catzc.Base.QualityGates.CommentEngine]::View($csResult.Text, '.cs', $csResult.PageText) | Should -BeExactly $csharp
    }

    It 'moves a delimited block that is not help, with its residue in the family line marker' -Tag 'ADR-PRIN-ONELIVE#1' {
        $source = "/*`n  Widget layout: gadgets first,`n  then the rest.`n*/`nvar widget = 1;`n"
        $result = & $export $source '.cs' 'csharp'
        $result.MovedCount | Should -Be 1
        $result.Text | Should -BeLike '// Widget layout: gadgets first, then the rest.*'
    }

    It 'cuts the provisional insight at a word to fit and collects each citation once' -Tag 'ADR-PRIN-CONFIG#1' {
        [Catzc.Base.QualityGates.CommentEngine]::Insight('First widget sentence. Second.', 120) | Should -Be 'First widget sentence.'
        [Catzc.Base.QualityGates.CommentEngine]::Insight('widget gadget widget gadget', 16) | Should -Be 'widget gadget...'
        [Catzc.Base.QualityGates.CommentEngine]::Citations('ADR-WIDGET:2, ADR-WIDGET#2 and ADR-GADGET') | Should -Be @('ADR-WIDGET#2', 'ADR-GADGET')
        [Catzc.Base.QualityGates.CommentEngine]::IsMechanical('ADR-WIDGET#2 [comment:1](/docs/x.md#comment1)') | Should -BeTrue
        [Catzc.Base.QualityGates.CommentEngine]::IsMechanical('Sorted so the widget order is stable') | Should -BeFalse
    }

    It 'keeps a block whose head the language keeps, and moves nothing below min_lines' -Tag 'ADR-PRIN-CONFIG#1' {
        $kept = [Catzc.Base.QualityGates.CommentsConfig]::new(@{ keep = @{ yaml = @('# widget-schema:') }; min_lines = 3 })
        $yaml = "# widget-schema: gadget`n# second line`n# third line`nwidget: 1`n# two lines`n# only`ngadget: 2`n"
        [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($yaml, '.yml', 'yaml', $kept).Count | Should -Be 0
    }
}
