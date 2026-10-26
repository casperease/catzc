# Rests on [PDR-ONELIVE-ONEVERSION](/docs/drs/principles/one-living-version.md#rule-pdr-onelive-oneversion).
# cspell:ignore nwidgets npublic nvar nwidget ngadget gadgt wdgt -- escape-sequence artifacts in the "`n…" fixture
# strings, and the deliberate misspelling a kept cspell directive covers
Describe 'CommentEngine' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:config = [Catzc.Base.QualityGates.CommentsConfig]::new(@{})
        $script:page = 'docs/references/pwsh/catzc-widget/Get-Widget.ps1.md'
        $script:export = {
            param([string] $Text, [string] $Extension = '.ps1', [string] $Language = 'powershell',
                [string] $PageText = $null)
            [Catzc.Base.QualityGates.CommentEngine]::Export($Text, $Extension, $Language,
                'widgets/Catzc.Widget/Get-Widget.ps1',
                $script:page, $PageText, $script:config)
        }
        $script:source = @(
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

    It 'finds the line runs with enough prose, not the kept heads, short ones, or trailing comments' -Tag 'PDR-CONFIG-VARYINGBEHAVIOURISCONFIG', 'ADR-REPO-COMMENTS-CLUESNOTNARRATION' {
        $blocks = [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($source, '.ps1', 'powershell', $config)
        $blocks.Count | Should -Be 1
        $blocks[0].Kind | Should -Be ([Catzc.Base.QualityGates.CommentBlockKind]::LineRun)
        $blocks[0].Marker | Should -Be '#'
        $blocks[0].Indent | Should -Be '    '
        $blocks[0].Lines | Should -Be @('Sorted first, so the gadget order is stable',
            'across runs and the cache key never changes.')
    }

    It 'leaves nothing behind for a moved comment and names the code line it sat above on the page' -Tag 'ADR-REPO-COMMENTS-ONELINEOFINSIGHT', 'ADR-REPO-COMMENTS-MOVELOSESNOTHING' {
        $result = & $export $source
        $result.MovedCount | Should -Be 1
        $result.Text | Should -Not -Match 'comment:'
        $result.Text | Should -Not -Match 'Sorted first'
        ($result.Text -split "`n") | Should -Contain '    $widgets = Get-Gadget | Sort-Object   # a trailing note stays'
        ($result.Text -split "`n") | Should -Contain '    # One line stays.'
        $result.PageText.StartsWith("# widgets/Catzc.Widget/Get-Widget.ps1`n`nThe comments of the file that outgrew one line") | Should -BeTrue -Because 'the title is the file the page belongs to'
        $section = "## comment:1`n`nAbove ``" + '$widgets = Get-Gadget | Sort-Object   # a trailing note stays' + "``, written with ``#``.`n`n" + '```text' + "`nSorted first, so the gadget order is stable`nacross runs and the cache key never changes.`n" + '```'
        $result.PageText.Contains($section) |
            Should -BeTrue -Because 'a section names its code line and fences the prose, indent stripped'
    }

    It 'puts every section back above its code line in the view' -Tag 'ADR-REPO-COMMENTS-INLINEVIEWGENERATED' {
        $result = & $export $source
        [Catzc.Base.QualityGates.CommentEngine]::View($result.Text, '.ps1', $result.PageText) |
            Should -BeExactly $source
    }

    It 'is idempotent: a second export moves nothing and changes nothing' -Tag 'ADR-AUTO-IDEM-CHECKBEFOREACTING' {
        $first = & $export $source
        $second = & $export $first.Text '.ps1' 'powershell' $first.PageText
        $second.Changed | Should -BeFalse
        $second.MovedCount | Should -Be 0
    }

    It 'numbers a new comment after the page''s highest section and keeps the existing sections as written' -Tag 'ADR-REPO-COMMENTS-MOVELOSESNOTHING' {
        $first = & $export $source
        $edited = $first.PageText -replace 'across runs', 'across all runs'
        $grown = $first.Text -replace '    # One line stays.', "    # A new gadget note`n    # that spans two lines."
        $second = & $export $grown '.ps1' 'powershell' $edited
        $second.MovedCount | Should -Be 1
        $second.PageText.IndexOf('across all runs') | Should -BeLessThan $second.PageText.IndexOf('## comment:2')
        $second.PageText.Contains('## comment:2') | Should -BeTrue
        $view = [Catzc.Base.QualityGates.CommentEngine]::View($second.Text, '.ps1', $second.PageText)
        $view.Contains('across all runs') | Should -BeTrue
        $view.Contains('# A new gadget note') | Should -BeTrue
    }

    It 'tells a repeated code line apart by its occurrence' -Tag 'ADR-REPO-COMMENTS-MOVELOSESNOTHING' {
        $text = "function Get-Widget {`n    `$widget`n    # A gadget note`n    # on two lines.`n    `$widget`n}`n"
        $result = & $export $text
        $result.PageText.Contains('(occurrence 2)') | Should -BeTrue
        [Catzc.Base.QualityGates.CommentEngine]::View($result.Text, '.ps1', $result.PageText) | Should -BeExactly $text
    }

    It 'places a comment at the end of the file when no code follows it' -Tag 'ADR-REPO-COMMENTS-MOVELOSESNOTHING' {
        $text = "`$widget = 1`n# A trailing gadget note`n# on two lines.`n"
        $result = & $export $text
        $result.Text | Should -BeExactly "`$widget = 1`n"
        $result.PageText.Contains('At the end of the file, written with `#`.') | Should -BeTrue
        [Catzc.Base.QualityGates.CommentEngine]::View($result.Text, '.ps1', $result.PageText) | Should -BeExactly $text
    }

    It 'reports a section whose code line the file no longer has as an orphan' -Tag 'ADR-REPO-COMMENTS-MOVEDBYTOOL' {
        $result = & $export $source
        [Catzc.Base.QualityGates.CommentEngine]::Orphans($result.Text, $result.PageText).Count | Should -Be 0
        $edited = $result.Text -replace 'Sort-Object', 'Sort-Object -Unique'
        [Catzc.Base.QualityGates.CommentEngine]::Orphans($edited, $result.PageText) | Should -Be @(1)
        [Catzc.Base.QualityGates.CommentEngine]::View($edited, '.ps1', $result.PageText) |
            Should -BeExactly $edited -Because 'a section with no line is left out of the view'
    }

    It 'anchors a Describe line on its name before the first -Tag, so a re-tier orphans nothing' -Tag 'ADR-REPO-COMMENTS-MOVELOSESNOTHING' {
        $text = "# A widget suite note`n# on two lines.`nDescribe 'Get-Widget' -Tag 'L0', 'logic' {`n}`n"
        $result = & $export $text
        $result.PageText.Contains("Above ``Describe 'Get-Widget'``, written with ``#``.") | Should -BeTrue
        $retiered = $result.Text -replace "'L0', 'logic'", "'L2', 'integration'"
        [Catzc.Base.QualityGates.CommentEngine]::Orphans($retiered, $result.PageText).Count | Should -Be 0
        [Catzc.Base.QualityGates.CommentEngine]::View($retiered, '.ps1',
            $result.PageText).Contains('# A widget suite note') | Should -BeTrue
    }

    It 'round-trips a YAML header and a CRLF file, keeping the file''s line endings' -Tag 'ADR-REPO-COMMENTS-MOVELOSESNOTHING' {
        $yaml = "# The gadget registry: one entry per widget,`r`n# read once per run.`r`nwidgets:`r`n  - gadget   # inline stays`r`n"
        $yamlResult = & $export $yaml '.yml' 'yaml'
        $yamlResult.MovedCount | Should -Be 1
        $yamlResult.Text | Should -BeExactly "widgets:`r`n  - gadget   # inline stays`r`n"
        [Catzc.Base.QualityGates.CommentEngine]::View($yamlResult.Text, '.yml', $yamlResult.PageText) |
            Should -BeExactly $yaml
    }

    It 'moves a C# line run with its own marker' -Tag 'ADR-REPO-COMMENTS-MOVELOSESNOTHING' {
        $csharp = "namespace Widget;`n`n/// The gadget cache, keyed by widget,`n/// so a lookup is one hash.`npublic sealed class Gadget { }`n"
        $csResult = & $export $csharp '.cs' 'bcl'
        $csResult.PageText.Contains('written with `///`') | Should -BeTrue
        $csResult.Text.Contains('///') | Should -BeFalse
        [Catzc.Base.QualityGates.CommentEngine]::View($csResult.Text, '.cs', $csResult.PageText) |
            Should -BeExactly $csharp
    }

    It 'moves a delimited block, which the view writes back as line comments in the family marker' -Tag 'ADR-REPO-COMMENTS-MOVELOSESNOTHING' {
        $text = "/*`n  Widget layout: gadgets first,`n  then the rest.`n*/`nvar widget = 1;`n"
        $result = & $export $text '.cs' 'bcl'
        $result.MovedCount | Should -Be 1
        $result.Text | Should -BeExactly "var widget = 1;`n"
        $view = [Catzc.Base.QualityGates.CommentEngine]::View($result.Text, '.cs', $result.PageText)
        $view | Should -BeLike '*// Widget layout: gadgets first,*// then the rest.*var widget = 1;*'
    }

    It 'keeps a delimited block whole when it holds a kept head, as comment-based help does' -Tag 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE' {
        $help = "<#`n.SYNOPSIS`n    Gets a widget.`n.DESCRIPTION`n    Reads the widget from the gadget store first,`n    because the store is the one living copy.`n#>`n" + 'function Get-Widget { }' + "`n"
        [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($help, '.ps1', 'powershell', $config).Count | Should -Be 0
        $plain = "<#`n    Reads the widget from the gadget store first,`n    because the store is the one living copy.`n#>`n" + 'function Get-Widget { }' + "`n"
        [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($plain, '.ps1', 'powershell', $config).Count | Should -Be 1
    }

    It 'keeps a directive inside a run in place and moves the prose around it' -Tag 'ADR-REPO-COMMENTS-ONELINEOFINSIGHT' {
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
        $result.Text | Should -BeExactly "# cspell:ignore gadgt`ngadgt: 1`n"
        $result.PageText.Contains("# widgets/Catzc.Widget/Get-Widget.ps1`n`n<!-- cspell:ignore gadgt -->`n") |
            Should -BeTrue -Because 'the page ignores what the file ignores'
    }

    It 'merges the ignored words into an existing page once' -Tag 'ADR-REPO-COMMENTS-MOVELOSESNOTHING' {
        [Catzc.Base.QualityGates.CommentEngine]::IgnoredWords("# cspell:ignore gadgt wdgt  -- fixture typos`nwidget: 1`n", '.yml') |
            Should -Be @('gadgt', 'wdgt')
        $first = & $export "# cspell:ignore gadgt`n# A widget note`n# on two lines.`nwidget: 1`n" '.yml' 'yaml'
        $grown = $first.Text + "# cspell:ignore wdgt`n# A gadget note`n# on two lines.`ngadget: 2`n"
        $second = & $export $grown '.yml' 'yaml' $first.PageText
        ([regex]::Matches($second.PageText, 'cspell:ignore')).Count | Should -Be 1
        $second.PageText.Contains('<!-- cspell:ignore gadgt wdgt -->') | Should -BeTrue
    }

    It 'wraps many ignored words into several lines within the page limit, and merges them back on re-export' -Tag 'ADR-REPO-COMMENTS-MOVELOSESNOTHING' {
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

    It 'cuts a long code line at a word, never inside one' -Tag 'ADR-REPO-COMMENTS-MOVELOSESNOTHING' {
        $long = '$widgets = Get-Gadget -Name widget -Filter gadget -Recurse -Depth 3 -ErrorAction Ignore -Force'
        $result = & $export "# A long widget note`n# on two lines.`n$long`n"
        $result.PageText.Contains('$widgets = Get-Gadget -Name widget -Filter gadget -Recurse -Depth 3...') |
            Should -BeTrue
        [Catzc.Base.QualityGates.CommentEngine]::View($result.Text, '.ps1', $result.PageText) |
            Should -BeExactly "# A long widget note`n# on two lines.`n$long`n"
    }

    It 'names the code line in a code span that survives the backticks inside it' -Tag 'ADR-REPO-COMMENTS-MOVELOSESNOTHING' {
        [Catzc.Base.QualityGates.CommentBlock]::CodeSpan('$widget = 1') | Should -BeExactly '`$widget = 1`'
        [Catzc.Base.QualityGates.CommentBlock]::CodeSpan('Get-Gadget "`"$name`""') |
            Should -BeExactly '``Get-Gadget "`"$name`""``'
        [Catzc.Base.QualityGates.CommentBlock]::CodeSpan('`widget``') | Should -BeExactly '``` `widget`` ```'
    }

    It 'keeps the whole run a keep_run head opens, and still moves the prose after the blank line' -Tag 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE', 'ADR-REPO-CODEMETA-COMMENTSLEAVEHEAD' {
        $head = [Catzc.Base.QualityGates.CommentsConfig]::new(@{ keep_run = @{ yaml = @('# catzc:') } })
        $yaml = "# catzc:`n#   path: docs/widget.yml`n#   module: Catzc.Widget`n`n# The widget registry, one entry per gadget,`n# read once per run.`ngadget: 1`n"
        $blocks = [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($yaml, '.yml', 'yaml', $head)
        $blocks.Count | Should -Be 1
        $blocks[0].StartLine | Should -Be 4
        $moved = [Catzc.Base.QualityGates.CommentEngine]::Export($yaml, '.yml', 'yaml',
            'widgets/Catzc.Widget/widget.yml', $script:page, $null, $head)
        $moved.MovedCount | Should -Be 1
        $moved.Text.StartsWith("# catzc:`n#   path: docs/widget.yml`n#   module: Catzc.Widget`n`n") | Should -BeTrue
    }

    It 'keeps a line-comment head that opens with its front matter fence, in each line marker' -Tag 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE', 'ADR-REPO-CODEMETA-COMMENTSLEAVEHEAD' {
        $head = [Catzc.Base.QualityGates.CommentsConfig]::new(@{ keep_run = @{ yaml = @('# catzc:'); bicep = @('// catzc:') } })
        $yaml = "# ---`n# catzc:`n#   immutable:`n#     path: docs/widget.yml`n#     kind: config`n# ---`n`n# The widget registry, one entry per gadget,`n# read once per run.`ngadget: 1`n"
        $blocks = [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($yaml, '.yml', 'yaml', $head)
        $blocks.Count | Should -Be 1
        $blocks[0].StartLine | Should -Be 7
        $bicep = "// ---`n// catzc:`n//   immutable:`n//     path: docs/widget.bicep`n// ---`n`nparam gadget string`n"
        [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($bicep, '.bicep', 'bicep', $head).Count | Should -Be 0
    }

    It 'reads a fence over an unlisted line as prose, so the run is a block' -Tag 'ADR-REPO-CODEMETA-COMMENTSLEAVEHEAD' {
        $head = [Catzc.Base.QualityGates.CommentsConfig]::new(@{ keep_run = @{ yaml = @('# catzc:') } })
        $yaml = "# ---`n# A widget note`n# on two lines.`n`ngadget: 1`n"
        [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($yaml, '.yml', 'yaml', $head).Count | Should -Be 1
    }

    It 'reads a head the config does not list as prose, so the run is a block' -Tag 'ADR-REPO-CODEMETA-COMMENTSLEAVEHEAD' {
        $yaml = "# catzc:`n#   path: docs/widget.yml`n#   module: Catzc.Widget`n`ngadget: 1`n"
        [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($yaml, '.yml', 'yaml',
            [Catzc.Base.QualityGates.CommentsConfig]::new(@{})).Count | Should -Be 1
    }

    It 'keeps a keep_run head in the middle of prose from hiding the lines after it' -Tag 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE' {
        $head = [Catzc.Base.QualityGates.CommentsConfig]::new(@{ keep_run = @{ yaml = @('# catzc:') } })
        $yaml = "# A widget note`n# on two lines.`n# catzc:`n# more gadget prose`n# on two lines.`ngadget: 1`n"
        [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($yaml, '.yml', 'yaml', $head).Count | Should -Be 1
    }

    It 'does not let a single-line keep head hide the prose directly under it' -Tag 'ADR-REPO-COMMENTS-COMMENTPAGEPLACE' {
        $yaml = "# cspell:ignore gadgt`n# A widget note`n# on two lines.`ngadget: 1`n"
        [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($yaml, '.yml', 'yaml',
            [Catzc.Base.QualityGates.CommentsConfig]::new(@{})).Count | Should -Be 1
    }

    It 'keeps a block whose head the language keeps, and moves nothing below min_lines' -Tag 'PDR-CONFIG-VARYINGBEHAVIOURISCONFIG' {
        $kept = [Catzc.Base.QualityGates.CommentsConfig]::new(@{ keep = @{ yaml = @('# widget-schema:') }; min_lines = 3 })
        $yaml = "# widget-schema: gadget`n# second line`n# third line`nwidget: 1`n# two lines`n# only`ngadget: 2`n"
        [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($yaml, '.yml', 'yaml', $kept).Count | Should -Be 0
    }
}
