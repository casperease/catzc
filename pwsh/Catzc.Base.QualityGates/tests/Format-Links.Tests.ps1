<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/tests/Format-Links.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Format-Links' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:writeFile = {
            param([string] $Root, [string] $Relative, [string] $Text)
            $full = Join-Path $Root $Relative
            [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($full, $Text)
        }
        $script:readFile = {
            param([string] $Root, [string] $Relative)
            [System.IO.File]::ReadAllText((Join-Path $Root $Relative))
        }
        $script:newRepository = {
            $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
            & $script:writeFile $root '.editorconfig' ((@('[*.{ps1,psm1,psd1}]', 'max_line_length = 120', '') -join "`n"))
            & $script:writeFile $root 'docs/drs/index.md' ((@(
                        '| Code | ADR |'
                        '| ---- | --- |'
                        '| `ADR-TST-WIDGET` | [widget-rules](widget/widget-rules.md) |'
                        '| `ADR-TST-GADGET` | [gadget-rules](gadget/gadget-rules.md) |'
                    ) -join "`n") + "`n")
            & $script:writeFile $root 'docs/drs/widget/widget-rules.md' ((@(
                        '# Widget rules', '', '### Rule ADR-TST-WIDGET-SPIN', '', 'One.', '', '### Rule ADR-TST-WIDGET-NEST', '', 'Two.', '', '## Widget notes', ''
                    ) -join "`n"))
            & $script:writeFile $root 'docs/drs/gadget/gadget-rules.md' ((@('# Gadget rules', '', '### Rule ADR-TST-GADGET-TURN', '', 'One.', '') -join "`n"))
            & $script:writeFile $root 'docs/drs/widget/dora-explains.md' "# Widget DORA`n"
            & $script:writeFile $root 'docs/drs/gadget/dora-explains.md' "# Gadget DORA`n"
            $root
        }
        # Aligns one fixture file and returns its new text.
        $script:alignFile = {
            param([string] $Root, [string] $Relative, [string] $Text)
            & $script:writeFile $Root $Relative $Text
            Format-Links -RepositoryRoot $Root -Path (Join-Path $Root $Relative) | Out-Null
            & $script:readFile $Root $Relative
        }
        $script:widget2 = '[ADR-TST-WIDGET-NEST](/docs/drs/widget/widget-rules.md#rule-adr-tst-widget-nest)'
        $script:widgetDoc = '[ADR-TST-WIDGET](/docs/drs/widget/widget-rules.md)'
    }

    BeforeEach {
        $script:root = & $script:newRepository
    }

    Context 'code links' {
        It 'turns a bare docs path in a comment into a code link' -Tag 'ADR-REPO-LINK-CODELINKS' {
            & $alignFile $root 'src/widget.ps1' "# See docs/drs/widget/widget-rules.md.`n" |
                Should -BeExactly "# See $widgetDoc.`n"
        }

        It 'turns a relative docs path into a repository-rooted code link' -Tag 'ADR-REPO-LINK-CODELINKS' {
            & $alignFile $root 'src/widget.ps1' "# See ../../docs/drs/widget/widget-rules.md#rule-adr-tst-widget-nest.`n" |
                Should -BeExactly "# See $widget2.`n"
        }

        It 'turns a bare named rule citation into a rule link, and leaves a numbered one as written' -Tag 'ADR-REPO-LINK-CODELINKS', 'ADR-REPO-LINK-ONECITATIONSPELLING' {
            & $alignFile $root 'src/widget.ps1' "# Widgets nest (ADR-TST-WIDGET-NEST).`n# Gadgets too (ADR-TST-WIDGET#2).`n" |
                Should -BeExactly "# Widgets nest ($widget2).`n# Gadgets too (ADR-TST-WIDGET#2).`n"
        }

        It 'leaves the codes of a meta head as plain codes, in a block head and in a prefixed one' -Tag 'ADR-REPO-LINK-CODELINKS', 'ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY' {
            $block = "/*`n---`ncatzc:`n  edges:`n    cites:`n      - ADR-TST-WIDGET-NEST`n      - ADR-TST-GADGET`n---`n*/`n"
            & $alignFile $root 'src/widget.cs' "$block`n// Follows ADR-TST-WIDGET throughout.`n" |
                Should -BeExactly "$block`n// Follows $widgetDoc throughout.`n"
            $help = "<#`n---`ncatzc:`n  edges:`n    cites:`n      - ADR-TST-WIDGET-NEST`n---`n#>`n"
            & $alignFile $root 'src/widget.ps1' $help | Should -BeExactly $help
        }

        It 'turns a bare ADR code into a whole-ADR link' -Tag 'ADR-REPO-LINK-CODELINKS' {
            & $alignFile $root 'src/widget.ps1' "# Follows ADR-TST-WIDGET throughout.`n" |
                Should -BeExactly "# Follows $widgetDoc throughout.`n"
        }

        It 'merges a path and its own citation into one link' -Tag 'ADR-REPO-LINK-CODELINKS' {
            & $alignFile $root 'src/widget.ps1' "# Per docs/drs/widget/widget-rules.md (ADR-TST-WIDGET-NEST) here.`n" |
                Should -BeExactly "# Per $widget2 here.`n"
            & $alignFile $root 'src/gadget.ps1' "# Per (docs/drs/widget/widget-rules.md, Rule ADR-TST-WIDGET-NEST).`n" |
                Should -BeExactly "# Per ($widget2).`n"
        }

        It 'merges a citation and the bracketed link to the same rule after it into one link, keeping a link elsewhere' -Tag 'ADR-REPO-LINK-CODELINKS' {
            $text = @(
                '<#'
                '.DESCRIPTION'
                '    The widget rule of ADR-TST-WIDGET-NEST'
                '    ([widget-rules](/docs/drs/widget/widget-rules.md#rule-adr-tst-widget-nest)): widgets nest.'
                '    Gadgets follow ADR-TST-WIDGET-NEST ([gadget-rules](/docs/drs/gadget/gadget-rules.md)).'
                '#>'
                ''
            ) -join "`n"
            $expected = @(
                '<#'
                '.DESCRIPTION'
                "    The widget rule of $($widget2): widgets nest."
                "    Gadgets follow $widget2"
                '    ([ADR-TST-GADGET](/docs/drs/gadget/gadget-rules.md)).'
                '#>'
                ''
            ) -join "`n"
            & $alignFile $root 'src/widget.ps1' $text | Should -BeExactly $expected
        }

        It 'turns a unique ADR file name into a link, and leaves an ambiguous one alone' -Tag 'ADR-REPO-LINK-CODELINKS' {
            & $alignFile $root 'src/widget.ps1' "# See gadget-rules.md and dora-explains.md.`n" |
                Should -BeExactly "# See [ADR-TST-GADGET](/docs/drs/gadget/gadget-rules.md) and dora-explains.md.`n"
        }

        It 're-points a path to a moved ADR from its file name' -Tag 'ADR-REPO-LINK-CODELINKS' {
            & $alignFile $root 'src/widget.ps1' "# See docs/drs/old-folder/widget-rules.md.`n" |
                Should -BeExactly "# See $widgetDoc.`n"
        }

        It 'resolves a link whose destination disagrees with its citation in favour of the citation' -Tag 'ADR-REPO-LINK-CODELINKS' {
            & $alignFile $root 'src/widget.ps1' "# See [ADR-TST-WIDGET-NEST](/docs/drs/gadget/gadget-rules.md).`n" |
                Should -BeExactly "# See $widget2.`n"
        }

        It 'links a code-less ADR-folder document with its file name as the text' -Tag 'ADR-REPO-LINK-CODELINKS' {
            & $alignFile $root 'src/widget.ps1' "# Registry: docs/drs/index.md.`n" |
                Should -BeExactly "# Registry: [index](/docs/drs/index.md).`n"
        }

        It 'aligns C# and YAML comments too' -Tag 'ADR-REPO-LINK-KINDBYFILE', 'ADR-REPO-LINK-CODELINKS' {
            # A string or value is data: its citation stays plain, never a link.
            & $alignFile $root 'src/Gadget.cs' ((@('// Per ADR-TST-WIDGET-NEST.', 'var s = "ADR-TST-WIDGET-NEST";', '') -join "`n")) |
                Should -BeExactly ((@("// Per $widget2.", 'var s = "ADR-TST-WIDGET-NEST";', '') -join "`n"))
            & $alignFile $root 'src/gadget.yml' "# Per ADR-TST-WIDGET-NEST.`nkey: ADR-TST-WIDGET-NEST`n" |
                Should -BeExactly "# Per $widget2.`nkey: ADR-TST-WIDGET-NEST`n"
        }
    }

    Context 'rule citations in string literals' {
        It 'leaves a numbered citation in a PowerShell, C#, or YAML string as written, keeping a rule heading' -Tag 'ADR-REPO-LINK-ONECITATIONSPELLING', 'ADR-REPO-LINK-STRINGSAREDATA' {
            & $alignFile $root 'src/widget.ps1' "throw 'widgets nest (ADR-TST-WIDGET:2)'`n`$doc = `"### Rule ADR-TST-WIDGET-NEST`"`n" |
                Should -BeExactly "throw 'widgets nest (ADR-TST-WIDGET:2)'`n`$doc = `"### Rule ADR-TST-WIDGET-NEST`"`n"
            & $alignFile $root 'src/Gadget.cs' "class Gadget { const string Why = `"ADR-TST-GADGET#1`"; }`n" |
                Should -BeExactly "class Gadget { const string Why = `"ADR-TST-GADGET#1`"; }`n"
            & $alignFile $root 'src/widget.yml' "rule: ADR-TST-WIDGET:1`n" | Should -BeExactly "rule: ADR-TST-WIDGET:1`n"
        }

        It 'reports each numbered string citation as unfixable' -Tag 'ADR-REPO-LINK-ONECITATIONSPELLING' {
            & $writeFile $root 'src/widget.ps1' "throw 'widgets nest (ADR-TST-WIDGET:2)'`n"
            $result = Format-Links -RepositoryRoot $root -Path (Join-Path $root 'src/widget.ps1') -DryRun -PassThru
            @($result.Unfixable.Type) | Should -Be @('StringNumbered')
            $result.Unfixable[0].Line | Should -Be 1
        }

        It 'reports a numbered citation composed at runtime, and leaves a composed named one alone' -Tag 'ADR-REPO-LINK-ONECITATIONSPELLING' {
            # Built from two strings, so the string-citation check reads no composed citation in this file.
            $composed = "`$issues.Add(`"[ADR-TST-WIDGET" + "#`${Rule}] `$Message`")`n"
            $formatted = 'var s = string.Format("ADR-TST-GADGET' + ':{0}", n);' + "`n"
            $named = "`$issues.Add(`"[ADR-TST-WIDGET-`$Name] `$Message`")`n`$text = `"ADR-TST-WIDGET: `$Message`"`n"
            & $writeFile $root 'src/widget.ps1' ($composed + $named)
            & $writeFile $root 'src/Gadget.cs' $formatted
            $result = Format-Links -RepositoryRoot $root -Path (Join-Path $root 'src/widget.ps1'), (Join-Path $root 'src/Gadget.cs') -DryRun -PassThru
            @($result.Unfixable.Type) | Should -Be @('StringNumbered', 'StringNumbered')
            @($result.Unfixable | Where-Object Line -NE 1) | Should -BeNullOrEmpty
        }
    }

    Context 'what stays as written' {
        It 'leaves a path glued to a placeholder, and a code with a placeholder suffix, alone' -Tag 'ADR-REPO-LINK-CODELINKS' {
            $text = "# Reads <root>/docs/drs/widget/widget-rules.md and x/gadget-rules.md; codes ADR-TST-WIDGET-<NAME>.`n"
            & $alignFile $root 'src/widget.ps1' $text | Should -BeExactly $text
        }

        It 'never turns a citation or path inside a PowerShell string into a link' -Tag 'ADR-REPO-LINK-STRINGSAREDATA' {
            $text = "`$tag = 'ADR-TST-WIDGET-NEST'`n`$path = 'docs/drs/widget/widget-rules.md'`n"
            & $alignFile $root 'src/widget.ps1' $text | Should -BeExactly $text
        }

        It 'leaves code spans, quoted examples, and help .EXAMPLE sections literal' -Tag 'ADR-REPO-LINK-CODELINKS' {
            $text = @(
                '<#'
                '.DESCRIPTION'
                "    The registry form is 'ADR-TST-WIDGET-NEST'; see ``ADR-TST-WIDGET-NEST``."
                '.EXAMPLE'
                '    Test-Widget -Rule ADR-TST-WIDGET-NEST'
                '#>'
                ''
            ) -join "`n"
            & $alignFile $root 'src/widget.ps1' $text | Should -BeExactly $text
        }

        It 'reports, without rewriting, an undeclared rule, an unknown code, and a dangling path' -Tag 'ADR-REPO-LINK-ONECITATIONSPELLING' {
            $text = "# ADR-TST-WIDGET-MISSING, ADR-TST-SPROCKET, docs/drs/nowhere/sprocket.md`n"
            & $writeFile $root 'src/widget.ps1' $text
            $result = Format-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -PassThru
            & $readFile $root 'src/widget.ps1' | Should -BeExactly $text
            @($result.Unfixable.Type) | Should -Be @('UnknownRule', 'UnknownCode', 'Dangling')
        }

        It 'tolerates fixture codes in a test file''s comments' -Tag 'ADR-REPO-LINK-ONECITATIONSPELLING' {
            & $writeFile $root 'src/tests/Widget.Tests.ps1' "# Fixture ADR-TST-SPROCKET is unregistered on purpose.`n"
            $result = Format-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -PassThru
            $result.Unfixable | Should -BeNullOrEmpty
        }

        It 'reports a docs path in a string that names no file' -Tag 'ADR-REPO-LINK-STRINGSAREDATA' {
            & $writeFile $root 'src/widget.ps1' "`$path = 'docs/drs/nowhere/widget.md'`n"
            $result = Format-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -PassThru
            @($result.Unfixable.Type) | Should -Be @('StringPathMissing')
        }

        It 'leaves a docs path in a string of a test fixture helper unreported' -Tag 'ADR-REPO-LINK-STRINGSAREDATA' {
            & $writeFile $root 'src/tests/Widget.Fixture.ps1' "`$path = 'docs/drs/nowhere/widget.md'`n"
            $result = Format-Links -RepositoryRoot $root -Path (Join-Path $root 'src/tests') -PassThru
            @($result.Unfixable | Where-Object Type -EQ 'StringPathMissing') | Should -BeNullOrEmpty
        }

        It 'leaves a contract asset as written, and never reports it' -Tag 'ADR-REPO-CONTRACT-CONTRACTASSET' {
            $asset = 'contracts/widget/0.0.0/Gadget/docs/widget.md'
            $text = "As ADR-TST-WIDGET-NEST says, see [nowhere](sprocket.md).`n"
            & $writeFile $root $asset $text
            # The fixture repository has no .git: report the class as .gitattributes declares it.
            Mock Get-GitAttributeValue { @{ 'contracts/widget/0.0.0/Gadget/docs/widget.md' = @{ 'catzc-contract' = 'set' } } } -ModuleName Catzc.Base.QualityGates
            $result = Format-Links -RepositoryRoot $root -Path (Join-Path $root 'contracts') -PassThru
            & $readFile $root $asset | Should -BeExactly $text
            $result.Unfixable | Should -BeNullOrEmpty
        }
    }

    Context 'markdown links' {
        It 'leaves a numbered prose citation as written, and the rule''s own heading alone' -Tag 'ADR-REPO-LINK-ONECITATIONSPELLING' {
            & $alignFile $root 'docs/widget.md' "### Rule ADR-TST-WIDGET-SPIN`n`nAs ADR-TST-WIDGET:2 says, but ``ADR-TST-WIDGET:2`` is code.`n" |
                Should -BeExactly "### Rule ADR-TST-WIDGET-SPIN`n`nAs ADR-TST-WIDGET:2 says, but ``ADR-TST-WIDGET:2`` is code.`n"
        }

        It 'rewrites a repository-rooted link relative to its file' -Tag 'ADR-REPO-LINK-MARKDOWNRELATIVE' {
            & $alignFile $root 'docs/guides/widget.md' "See [rules](/docs/drs/widget/widget-rules.md#widget-notes).`n" |
                Should -BeExactly "See [rules](../drs/widget/widget-rules.md#widget-notes).`n"
        }

        It 'reports a dangling target, a bad anchor, and a link above the root' -Tag 'ADR-REPO-LINK-MARKDOWNRELATIVE', 'ADR-REPO-LINK-OFFREPOSITORYURLS' {
            & $writeFile $root 'docs/widget.md' "[a](nowhere.md) [b](drs/widget/widget-rules.md#no-such-heading) [c](../../../gadget)`n"
            $result = Format-Links -RepositoryRoot $root -Path (Join-Path $root 'docs/widget.md') -PassThru
            @($result.Unfixable.Type) | Should -Be @('Dangling', 'BadAnchor', 'EscapesRoot')
        }
    }

    Context 'wrapping' {
        BeforeEach {
            Mock Get-Config -ParameterFilter { $Config -eq 'links' } -ModuleName Catzc.Base.QualityGates -MockWith {
                [Catzc.Base.QualityGates.LinksConfig]::new(@{ line_limit = @{ '.ps1' = 60 } })
            }
        }

        It 'breaks an outgrown comment line before the link, keeping the comment prefix and indent' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL' {
            & $alignFile $root 'src/widget.ps1' "    # Widgets nest gadgets per ADR-TST-WIDGET-NEST always.`n" |
                Should -BeExactly "    # Widgets nest gadgets per`n    # $widget2 always.`n"
        }

        It 'moves a trailing comment that outgrows its line above the statement, at the statement''s indentation' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL' {
            & $alignFile $root 'src/widget.ps1' "    `$x = 1   # widget per ADR-TST-WIDGET-NEST`n" |
                Should -BeExactly "    # widget per`n    # $widget2`n    `$x = 1`n"
        }

        It 'repairs a code link continued under a trailing comment''s marker by moving the comment above' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL' {
            & $alignFile $root 'src/widget.ps1' "    `$x = 1   # widget per`n             # $widget2`n" |
                Should -BeExactly "    # widget per`n    # $widget2`n    `$x = 1`n"
        }

        It 'leaves an aligned trailing comment block without a code link as written' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL' {
            $text = "`$x = 1   # widget`n         # gadget note`n"
            & $alignFile $root 'src/widget.ps1' $text | Should -BeExactly $text
        }

        It 'ends an inserted break with the file''s CRLF line ending' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL' {
            & $alignFile $root 'src/widget.ps1' "    # Widgets nest gadgets per ADR-TST-WIDGET-NEST always.`r`n`$x = 1`r`n" |
                Should -BeExactly "    # Widgets nest gadgets per`r`n    # $widget2 always.`r`n`$x = 1`r`n"
        }

        It 'reports instead of breaking under -Wrap Off' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL' {
            & $writeFile $root 'src/widget.ps1' "    # Widgets nest gadgets per ADR-TST-WIDGET-NEST always.`n"
            $findings = @(InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $root } {
                    (Invoke-LinkEngine -RepositoryRoot $Root -Path (Join-Path $Root 'src') -Kind Code -Wrap Off).Findings
                })
            @($findings | ForEach-Object { "$($_.Type)" }) | Should -Contain 'Overlong'

            $result = Format-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -Wrap Off -PassThru
            & $readFile $root 'src/widget.ps1' | Should -BeExactly "    # Widgets nest gadgets per $widget2 always.`n"
            $result.Unfixable | Should -BeNullOrEmpty
        }

        It 'takes the wrap mode from links.yml when -Wrap is omitted, and an explicit -Wrap wins' -Tag 'ADR-PWSH-PARAM-RESOLUTIONORDER' {
            Mock Get-Config -ParameterFilter { $Config -eq 'links' } -ModuleName Catzc.Base.QualityGates -MockWith {
                [Catzc.Base.QualityGates.LinksConfig]::new(@{ wrap = 'off'; line_limit = @{ '.ps1' = 60 } })
            }
            $text = "    # Widgets nest gadgets per ADR-TST-WIDGET-NEST always.`n"
            & $alignFile $root 'src/off.ps1' $text | Should -BeExactly "    # Widgets nest gadgets per $widget2 always.`n"

            & $writeFile $root 'src/break.ps1' $text
            Format-Links -RepositoryRoot $root -Path (Join-Path $root 'src/break.ps1') -Wrap Break | Out-Null
            & $readFile $root 'src/break.ps1' | Should -BeExactly "    # Widgets nest gadgets per`n    # $widget2 always.`n"
        }
    }

    Context 'engine contract' {
        It 'aligns only the kinds it is asked for' -Tag 'ADR-REPO-LINK-KINDBYFILE' {
            & $writeFile $root 'src/widget.ps1' "# ADR-TST-WIDGET-NEST`n"
            & $writeFile $root 'docs/widget.md' "See [rules](/docs/drs/widget/widget-rules.md#widget-notes).`n"
            Format-Links -RepositoryRoot $root -Path (Join-Path $root 'src'), (Join-Path $root 'docs/widget.md') -Kind Code | Out-Null
            & $readFile $root 'src/widget.ps1' | Should -BeExactly "# $widget2`n"
            & $readFile $root 'docs/widget.md' | Should -BeExactly "See [rules](/docs/drs/widget/widget-rules.md#widget-notes).`n"

            Format-Links -RepositoryRoot $root -Path (Join-Path $root 'docs/widget.md') -Kind Markdown | Out-Null
            & $readFile $root 'docs/widget.md' | Should -BeExactly "See [rules](drs/widget/widget-rules.md#widget-notes).`n"
        }

        It 'changes nothing on a second run' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL' {
            & $writeFile $root 'src/widget.ps1' "# See docs/drs/widget/widget-rules.md (ADR-TST-WIDGET-NEST) and ADR-TST-GADGET.`n"
            Format-Links -RepositoryRoot $root -Path (Join-Path $root 'src') | Out-Null
            @(Format-Links -RepositoryRoot $root -Path (Join-Path $root 'src')) | Should -BeNullOrEmpty
        }

        It 'writes nothing under -DryRun, and lists what would change' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL' {
            $text = "# ADR-TST-WIDGET-NEST`n"
            & $writeFile $root 'src/widget.ps1' $text
            $changed = @(Format-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -DryRun)
            $changed | Should -Be @('src/widget.ps1')
            & $readFile $root 'src/widget.ps1' | Should -BeExactly $text
        }

        It 'keeps the file''s CRLF line endings and writes no byte-order mark' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL' {
            & $writeFile $root 'src/widget.ps1' "# ADR-TST-WIDGET-NEST`r`n`$x = 1`r`n"
            Format-Links -RepositoryRoot $root -Path (Join-Path $root 'src') | Out-Null
            $bytes = [System.IO.File]::ReadAllBytes((Join-Path $root 'src/widget.ps1'))
            $bytes[0] | Should -Not -Be 0xEF
            & $readFile $root 'src/widget.ps1' | Should -BeExactly "# $widget2`r`n`$x = 1`r`n"
        }

        It 'aligns a few hundred files quickly (the compiled engine, in parallel)' -Tag 'ADR-REPO-LINK-ALIGNEDBYTOOL' {
            foreach ($n in 1..300) {
                & $writeFile $root "src/widget$n.ps1" "# Widget $n per docs/drs/widget/widget-rules.md and ADR-TST-WIDGET-NEST.`n`$x = $n`n"
            }
            $result = Format-Links -RepositoryRoot $root -Path (Join-Path $root 'src') -PassThru
            $result.ChangedCount | Should -Be 300
            $result.ElapsedMs | Should -BeLessThan 5000
        }
    }

    Context 'the summary line' {
        BeforeEach {
            Mock Write-Message { } -ModuleName Catzc.Base.QualityGates
            $script:messageRoot = & $script:newRepository
        }

        It 'says plainly that everything is already aligned when there is nothing to do' {
            & $script:writeFile $script:messageRoot 'src/widget.ps1' "# A widget with no citations at all.`n`$x = 1`n"
            Format-Links -RepositoryRoot $script:messageRoot -Path (Join-Path $script:messageRoot 'src') | Out-Null
            Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
                $Message -like 'Links: all 1 file(s) already aligned (* ms).'
            }
        }

        It 'counts what it aligned, and leaves out "need a person" when nobody is needed' {
            & $script:writeFile $script:messageRoot 'src/widget.ps1' "# Widget per ADR-TST-WIDGET-NEST.`n`$x = 1`n"
            Format-Links -RepositoryRoot $script:messageRoot -Path (Join-Path $script:messageRoot 'src') | Out-Null
            Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter {
                $Message -like 'Links: aligned 1 link(s) in 1 of 1 file(s) (* ms).'
            }
        }
    }
}
