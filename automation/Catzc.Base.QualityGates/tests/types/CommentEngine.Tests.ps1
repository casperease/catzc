<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/types/CommentEngine.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-IDEM#1
      - ADR-PRIN-CONFIG#1
      - ADR-PRIN-ONELIVE#1
      - ADR-REPO-CODEMETA#5
      - ADR-REPO-COMMENTS#1
      - ADR-REPO-COMMENTS#2
      - ADR-REPO-COMMENTS#3
      - ADR-REPO-LINK#9
---
#>

# cspell:ignore nwidgets npublic nvar nwidget ngadget gadgt wdgt nwidget  -- escape-sequence artifacts in the "`n…" fixture strings, and the
# deliberate misspelling a kept cspell directive covers CommentEngine moves a file's long comments to its comment...
# [comment:1](/docs/references/automation/catzc-base-qualitygates/tests/types/CommentEngine.Tests.ps1.md#comment1)
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

    It 'leaves one insight line per moved block, a docs link under a comment but none under a help section, and no citation' -Tag 'ADR-REPO-COMMENTS#2', 'ADR-REPO-LINK#9' {
        $result = & $export $helpSource
        $result.MovedCount | Should -Be 2
        $lines = $result.Text -split "`n"
        $lines | Should -Contain '    Reads the widget from the gadget store first, because the store is the one living copy.'
        $result.Text.Contains("[comment:1]") | Should -BeFalse -Because 'the page names the help section, which pairs it'
        $lines | Should -Contain '    # Sorted first, so the gadget order is stable across runs and the cache key never changes.'
        $lines | Should -Contain "    # [comment:2](/$page#comment2)"
        $lines | Should -Contain '    The widget name.'
        $lines | Should -Contain '    $widgets = Get-Gadget | Sort-Object   # a trailing note stays'
        $result.PageText.StartsWith("# automation/Catzc.Widget/Get-Widget.ps1`n`nThe comments of the file that outgrew one line") | Should -BeTrue -Because 'the title is the file the page belongs to'
        $section = "## comment:1`n`nSection ``.DESCRIPTION`` of the comment-based help.`n`n" + '```text' + "`nReads the widget from the gadget store first"
        $result.PageText.Contains($section) | Should -BeTrue -Because 'a section names its context and fences the prose, indent stripped'
        $result.PageText.Contains("`n`nA missing widget is created.`n" + '```') | Should -BeTrue -Because 'the blank line inside the comment is kept'
    }

    It 'round-trips: the view of the exported file is the original, byte for byte' -Tag 'ADR-REPO-COMMENTS#2' {
        $result = & $export $helpSource
        [Catzc.Base.QualityGates.CommentEngine]::View($result.Text, '.ps1', $result.PageText) | Should -BeExactly $helpSource
    }

    It 'is idempotent: a second export moves nothing and changes nothing' -Tag 'ADR-AUTO-IDEM#1' {
        $first = & $export $helpSource
        $second = & $export $first.Text '.ps1' 'powershell' $first.PageText
        $second.Changed | Should -BeFalse
        $second.MovedCount | Should -Be 0
    }

    It 'numbers a new comment after the page''s highest section and keeps the existing sections as written' -Tag 'ADR-REPO-COMMENTS#2' {
        $first = & $export $helpSource
        $edited = $first.PageText -replace 'A missing widget is created.', 'A missing widget is created on demand.'
        $grown = $first.Text -replace '    # One line stays.', "    # A new gadget note`n    # that spans two lines."
        $second = & $export $grown '.ps1' 'powershell' $edited
        $second.MovedCount | Should -Be 1
        $second.Text.Contains("[comment:3](/$page#comment3)") | Should -BeTrue
        $second.PageText.IndexOf('created on demand.') | Should -BeLessThan $second.PageText.IndexOf('## comment:3')
        [Catzc.Base.QualityGates.CommentEngine]::View($second.Text, '.ps1', $second.PageText).Contains('created on demand.') | Should -BeTrue
    }

    It 'finds every residue with its number, page and insight, pairing a help residue by its section name only with the page' -Tag 'ADR-REPO-COMMENTS#2', 'ADR-REPO-LINK#9' {
        $result = & $export $helpSource
        $residues = [Catzc.Base.QualityGates.CommentEngine]::FindResidues($result.Text, '.ps1', $page, $result.PageText)
        $residues.Count | Should -Be 2
        $residues[0].Number | Should -Be 1
        $residues[0].Page | Should -Be $page
        $residues[0].Insight | Should -BeLike 'Reads the widget*'
        $residues[0].Linked | Should -BeFalse
        $residues[0].HelpKeyword | Should -Be '.DESCRIPTION'
        $residues[0].LineCount | Should -Be 1
        $residues[1].Marker | Should -Be '#'
        $residues[1].LineCount | Should -Be 2
        $residues[1].Linked | Should -BeTrue
        @([Catzc.Base.QualityGates.CommentEngine]::FindResidues($result.Text, '.ps1')).Count | Should -Be 1 -Because 'without the page only a linked residue is found'
        [Catzc.Base.QualityGates.CommentEngine]::SectionNumbers($result.PageText) | Should -Be @(1, 2)
        [Catzc.Base.QualityGates.CommentEngine]::SectionLines($result.PageText, 2) |
            Should -Be @('Sorted first, so the gadget order is stable', 'across runs and the cache key never changes.')
        [Catzc.Base.QualityGates.CommentEngine]::SectionLines($result.PageText, 9).Count | Should -Be 0
    }

    It 'keeps the docs link of a help section another help block in the file also has, since its name pairs nothing uniquely' -Tag 'ADR-REPO-LINK#9' {
        $help = { param([string] $Name) @('<#', '.SYNOPSIS', "    The $Name.", '.DESCRIPTION', "    Reads the $Name from the gadget store,", '    because the store is the one living copy.', '#>', "function Get-$Name { }") }
        $text = ((& $help 'Widget') + (& $help 'Gadget') + '') -join "`n"
        $result = & $export $text
        $result.MovedCount | Should -Be 2
        $result.Text.Contains("[comment:1](/$page#comment1)") | Should -BeTrue
        $result.Text.Contains("[comment:2](/$page#comment2)") | Should -BeTrue
        [Catzc.Base.QualityGates.CommentEngine]::View($result.Text, '.ps1', $result.PageText) | Should -BeExactly $text
    }

    It 'pairs no help section whose name two page sections share' -Tag 'ADR-REPO-LINK#9' {
        $result = & $export $helpSource
        $doubled = $result.PageText + "`n## comment:9`n`nSection ``.DESCRIPTION`` of the comment-based help.`n`n" + '```text' + "`nA stale copy.`n" + '```' + "`n"
        $residues = @([Catzc.Base.QualityGates.CommentEngine]::FindResidues($result.Text, '.ps1', $page, $doubled))
        @($residues | Where-Object { -not $_.Linked }).Count | Should -Be 0
    }

    It 'round-trips a YAML header, a CRLF file, and a C# line run with its own marker' -Tag 'ADR-REPO-COMMENTS#2' {
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

    It 'moves a delimited block that is not help, with its residue in the family line marker' -Tag 'ADR-REPO-COMMENTS#2' {
        $source = "/*`n  Widget layout: gadgets first,`n  then the rest.`n*/`nvar widget = 1;`n"
        $result = & $export $source '.cs' 'csharp'
        $result.MovedCount | Should -Be 1
        $result.Text | Should -BeLike '// Widget layout: gadgets first, then the rest.*'
    }

    It 'cuts the provisional insight at a word to fit and collects each citation once' -Tag 'ADR-PRIN-CONFIG#1' {
        [Catzc.Base.QualityGates.CommentEngine]::Insight('First widget sentence. Second.', 120) | Should -Be 'First widget sentence.'
        [Catzc.Base.QualityGates.CommentEngine]::Insight('widget gadget widget gadget', 16) | Should -Be 'widget gadget...'
        # The ':' spelling is built, not written, so the string-citation check does not respell the input under test.
        $colonForm = 'ADR-WIDGET' + ':2'
        [Catzc.Base.QualityGates.CommentEngine]::Citations("$colonForm, ADR-WIDGET#2 and ADR-GADGET") | Should -Be @('ADR-WIDGET#2', 'ADR-GADGET')
        # A citation inside a code span is an example of the spelling: it is no citation, and the insight keeps it.
        [Catzc.Base.QualityGates.CommentEngine]::Citations('Spell it `ADR-WIDGET#8` or ADR-GADGET.') | Should -Be @('ADR-GADGET')
        [Catzc.Base.QualityGates.CommentEngine]::Insight('Spell it `ADR-WIDGET#8`, per ADR-GADGET.', 120) | Should -Be 'Spell it `ADR-WIDGET#8`, per.'
        [Catzc.Base.QualityGates.CommentEngine]::IsMechanical('ADR-WIDGET#2 [comment:1](/docs/x.md#comment1)') | Should -BeTrue
        [Catzc.Base.QualityGates.CommentEngine]::IsMechanical('Sorted so the widget order is stable') | Should -BeFalse
    }

    It 'keeps a directive inside a run in place and moves the prose around it' -Tag 'ADR-REPO-COMMENTS#1' {
        $yaml = (@(
                '# The widget registry, one entry per gadget,'
                '# read once per run.'
                '# cspell:ignore gadgt'
                '# Each key is a gadget name, each value'
                '# its widget count.'
                'gadgt: 1'
                ''
            ) -join "`n")
        $result = & $export $yaml '.yml' 'yaml'
        $result.MovedCount | Should -Be 2
        ($result.Text -split "`n")[2] | Should -BeExactly '# cspell:ignore gadgt'
        $result.PageText.Contains("# automation/Catzc.Widget/Get-Widget.ps1`n`n<!-- cspell:ignore gadgt -->`n") | Should -BeTrue -Because 'the page ignores what the file ignores'
        [Catzc.Base.QualityGates.CommentEngine]::View($result.Text, '.yml', $result.PageText) | Should -BeExactly $yaml
    }

    It 'merges the ignored words into an existing page once' -Tag 'ADR-REPO-COMMENTS#2' {
        [Catzc.Base.QualityGates.CommentEngine]::IgnoredWords("# cspell:ignore gadgt wdgt  -- fixture typos`nwidget: 1`n", '.yml') |
            Should -Be @('gadgt', 'wdgt')
        $first = & $export "# cspell:ignore gadgt`n# A widget note`n# on two lines.`nwidget: 1`n" '.yml' 'yaml'
        $grown = $first.Text + "# cspell:ignore wdgt`n# A gadget note`n# on two lines.`ngadget: 2`n"
        $second = & $export $grown '.yml' 'yaml' $first.PageText
        ([regex]::Matches($second.PageText, 'cspell:ignore')).Count | Should -Be 1
        $second.PageText.Contains('<!-- cspell:ignore gadgt wdgt -->') | Should -BeTrue
    }

    It 'wraps many ignored words into several lines within the page limit, and merges them back on re-export' -Tag 'ADR-REPO-COMMENTS#2' {
        $many = (1..30 | ForEach-Object { "gadget-widget-$_" }) -join ' '
        $first = & $export "# cspell:ignore $many`n# A widget note`n# on two lines.`nwidget: 1`n" '.yml' 'yaml'
        $ignoreLines = @($first.PageText -split "`n" | Where-Object { $_ -like '<!-- cspell:ignore*' })
        $ignoreLines.Count | Should -BeGreaterThan 1
        $ignoreLines | ForEach-Object { $_.Length | Should -BeLessOrEqual 140 }
        $grown = $first.Text + "# cspell:ignore wdgt`n# A gadget note`n# on two lines.`ngadget: 2`n"
        $second = & $export $grown '.yml' 'yaml' $first.PageText
        $words = @($second.PageText -split "`n" | Where-Object { $_ -like '<!-- cspell:ignore*' } |
                ForEach-Object { ($_ -replace '^<!-- cspell:ignore | -->$', '') -split ' ' })
        $words.Count | Should -Be 31
        $second.PageText | Should -Not -Match "`n`n`n"
    }

    It 'cuts a long annotated code line at a word, never inside one' -Tag 'ADR-REPO-COMMENTS#2' {
        $long = '$widgets = Get-Gadget -Name widget -Filter gadget -Recurse -Depth 3 -ErrorAction Ignore -Force'
        $source = "# A long widget note`n# on two lines.`n$long`n"
        $blocks = [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($source, '.ps1', 'powershell', $config)
        $blocks[0].NextCodeLine | Should -BeExactly '$widgets = Get-Gadget -Name widget -Filter gadget -Recurse -Depth 3...'
    }

    It 'names the annotated code line in a code span that survives the backticks inside it' -Tag 'ADR-REPO-COMMENTS#2' {
        [Catzc.Base.QualityGates.CommentBlock]::CodeSpan('$widget = 1') | Should -BeExactly '`$widget = 1`'
        [Catzc.Base.QualityGates.CommentBlock]::CodeSpan('Get-Gadget "`"$name`""') | Should -BeExactly '``Get-Gadget "`"$name`""``'
        [Catzc.Base.QualityGates.CommentBlock]::CodeSpan('`widget``') | Should -BeExactly '``` `widget`` ```'
    }

    It 'keeps the whole run a keep_run head opens, and still moves the prose after the blank line' -Tag 'ADR-REPO-COMMENTS#3', 'ADR-REPO-CODEMETA#5' {
        $head = [Catzc.Base.QualityGates.CommentsConfig]::new(@{ keep_run = @{ yaml = @('# catzc:') } })
        $yaml = "# catzc:`n#   path: docs/widget.yml`n#   module: Catzc.Widget`n`n# The widget registry, one entry per gadget,`n# read once per run.`ngadget: 1`n"
        $blocks = [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($yaml, '.yml', 'yaml', $head)
        $blocks.Count | Should -Be 1
        $blocks[0].StartLine | Should -Be 4
        $moved = [Catzc.Base.QualityGates.CommentEngine]::Export($yaml, '.yml', 'yaml', 'automation/Catzc.Widget/widget.yml', $script:page, $null, $head, 120)
        $moved.MovedCount | Should -Be 1
        $moved.Text.StartsWith("# catzc:`n#   path: docs/widget.yml`n#   module: Catzc.Widget`n`n") | Should -BeTrue
    }

    It 'keeps a line-comment head that opens with its front matter fence, in each line marker' -Tag 'ADR-REPO-COMMENTS#3', 'ADR-REPO-CODEMETA#5' {
        $head = [Catzc.Base.QualityGates.CommentsConfig]::new(@{ keep_run = @{ yaml = @('# catzc:'); bicep = @('// catzc:') } })
        $yaml = "# ---`n# catzc:`n#   derived:`n#     path: docs/widget.yml`n#     kind: config`n# ---`n`n# The widget registry, one entry per gadget,`n# read once per run.`ngadget: 1`n"
        $blocks = [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($yaml, '.yml', 'yaml', $head)
        $blocks.Count | Should -Be 1
        $blocks[0].StartLine | Should -Be 7
        $bicep = "// ---`n// catzc:`n//   derived:`n//     path: docs/widget.bicep`n// ---`n`nparam gadget string`n"
        [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($bicep, '.bicep', 'bicep', $head).Count | Should -Be 0
    }

    It 'reads a fence over an unlisted line as prose, so the run is a block' -Tag 'ADR-REPO-CODEMETA#5' {
        $head = [Catzc.Base.QualityGates.CommentsConfig]::new(@{ keep_run = @{ yaml = @('# catzc:') } })
        $yaml = "# ---`n# A widget note`n# on two lines.`n`ngadget: 1`n"
        [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($yaml, '.yml', 'yaml', $head).Count | Should -Be 1
    }

    It 'reads a head the config does not list as prose, so the run is a block' -Tag 'ADR-REPO-CODEMETA#5' {
        $yaml = "# catzc:`n#   path: docs/widget.yml`n#   module: Catzc.Widget`n`ngadget: 1`n"
        [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($yaml, '.yml', 'yaml', [Catzc.Base.QualityGates.CommentsConfig]::new(@{})).Count | Should -Be 1
    }

    It 'keeps a keep_run head in the middle of prose from hiding the lines after it' -Tag 'ADR-REPO-COMMENTS#3' {
        $head = [Catzc.Base.QualityGates.CommentsConfig]::new(@{ keep_run = @{ yaml = @('# catzc:') } })
        $yaml = "# A widget note`n# on two lines.`n# catzc:`n# more gadget prose`n# on two lines.`ngadget: 1`n"
        [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($yaml, '.yml', 'yaml', $head).Count | Should -Be 1
    }

    It 'does not let a single-line keep head hide the prose directly under it' -Tag 'ADR-REPO-COMMENTS#3' {
        $yaml = "# cspell:ignore gadgt`n# A widget note`n# on two lines.`ngadget: 1`n"
        [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($yaml, '.yml', 'yaml', [Catzc.Base.QualityGates.CommentsConfig]::new(@{})).Count | Should -Be 1
    }

    It 'keeps a block whose head the language keeps, and moves nothing below min_lines' -Tag 'ADR-PRIN-CONFIG#1' {
        $kept = [Catzc.Base.QualityGates.CommentsConfig]::new(@{ keep = @{ yaml = @('# widget-schema:') }; min_lines = 3 })
        $yaml = "# widget-schema: gadget`n# second line`n# third line`nwidget: 1`n# two lines`n# only`ngadget: 2`n"
        [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($yaml, '.yml', 'yaml', $kept).Count | Should -Be 0
    }
}
