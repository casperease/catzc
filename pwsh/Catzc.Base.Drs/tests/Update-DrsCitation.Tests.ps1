<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-drs/tests/Update-DrsCitation.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Update-DrsCitation' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $assets = Join-Path $PSScriptRoot 'assets/update-drs-citation'
        $script:codeMap = Join-Path $assets 'code-map.tsv'
        $script:ruleMap = Join-Path $assets 'rule-map.tsv'
        $script:utf8 = [System.Text.UTF8Encoding]::new($false)

        $script:writeBytes = {
            param([string] $Relative, [byte[]] $Bytes)
            $full = Join-Path $script:root $Relative
            [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
            [System.IO.File]::WriteAllBytes($full, $Bytes)
            $full
        }
        $script:writeText = {
            param([string] $Relative, [string] $Text)
            & $script:writeBytes $Relative $script:utf8.GetBytes($Text)
        }
        # Writes one file, rewrites it, and returns its new text; the changes land in $script:changes.
        $script:update = {
            param([string] $Relative, [string] $Text)
            $full = & $script:writeText $Relative $Text
            $script:changes = @(Update-DrsCitation -Path $full -CodeMap $script:codeMap -RuleMap $script:ruleMap -RepositoryRoot $script:root -InformationAction SilentlyContinue)
            [System.IO.File]::ReadAllText($full)
        }

        & $script:writeText 'docs/drs/index.md' ((@(
                    '| Code | ADR |'
                    '| ---- | --- |'
                    '| `ADR-WIDGET-SPROCKET` | [sprocket-rules](widget/sprocket-rules.md) |'
                    '| `ADR-WIDGET-COG` | [cog-rules](widget/cog-rules.md) |'
                    '| `ADR-GIZMO-GADGET` | [gadget-rules](gizmo/gadget-rules.md) |'
                    '| `ADR-GIZMO-LEVER` | [lever-rules](gizmo/lever-rules.md) |'
                ) -join "`n") + "`n") | Out-Null
        & $script:writeText 'docs/drs/widget/sprocket-rules.md' "# Sprocket`n`n### Rule ADR-WIDGET-SPROCKET-TURN`n`nOne.`n`n### Rule ADR-WIDGET-SPROCKET-DROP`n`nTwo.`n" | Out-Null
        & $script:writeText 'docs/drs/widget/cog-rules.md' "# Cog`n`n### Rule ADR-WIDGET-COG-SPINS`n`nOne.`n" | Out-Null
        & $script:writeText 'docs/drs/gizmo/gadget-rules.md' "# Gadget`n`n### Rule ADR-GIZMO-GADGET-TURN`n`nOne.`n" |
            Out-Null
        & $script:writeText 'docs/drs/gizmo/lever-rules.md' "# Lever`n`n### Rule ADR-GIZMO-LEVER-SPIN`n`nOne.`n" |
            Out-Null
    }

    Context 'citations' {
        It 'moves a code to another registered kind, its rule anchors with it' -Tag 'ADR-REPO-DRSCODE-PATHOFSEGMENTS' {
            $header = @('old_code', 'new_code', 'old_path', 'new_path', 'kind') -join "`t"
            $rows = foreach ($pair in @(@('ADR-WIDGET-COG', 'DDR-COG'), @('ADR-WIDGET-COG-SPINS', 'DDR-COG-SPINS'))) {
                @($pair[0], $pair[1], '-', 'widget/cog-rules.md', 'move') -join "`t"
            }
            $codeMap = & $script:writeText 'maps/kind-code-map.tsv' ($header + "`n" + ($rows -join "`n") + "`n")
            $full = & $script:writeText 'notes/kind.md' "See ADR-WIDGET-COG-SPINS in [cog](../docs/drs/widget/cog-rules.md#rule-adr-widget-cog-spins).`n"
            Update-DrsCitation -Path $full -CodeMap $codeMap -RuleMap $script:ruleMap -RepositoryRoot $script:root -InformationAction SilentlyContinue | Out-Null
            [System.IO.File]::ReadAllText($full) |
                Should -BeExactly "See DDR-COG-SPINS in [cog](../docs/drs/widget/cog-rules.md#rule-ddr-cog-spins).`n"
        }

        It 'carries a rule and its heading with its ADR''s code through the code map' {
            & $script:update 'notes/rename.md' "See ADR-WIDGET-GADGET-FOLD.`n### Rule ADR-WIDGET-GADGET-FOLD`n" |
                Should -BeExactly "See ADR-GIZMO-GADGET-FOLD.`n### Rule ADR-GIZMO-GADGET-FOLD`n"
        }

        It 'sends a moved rule and a collapsed rule where the rule map says, the rule map before the code map' {
            & $script:update 'notes/moved.md' 'ADR-WIDGET-SPROCKET-SPIN and ADR-WIDGET-GADGET-LIFT' |
                Should -BeExactly 'ADR-GIZMO-LEVER-SPIN and ADR-WIDGET-SPROCKET-DROP'
        }

        It 'rewrites each code of a list on its own' {
            & $script:update 'notes/list.md' 'ADR-WIDGET-GADGET-TURN, ADR-WIDGET-GADGET-LIFT and ADR-WIDGET-SPROCKET-SPIN' |
                Should -BeExactly 'ADR-GIZMO-GADGET-TURN, ADR-WIDGET-SPROCKET-DROP and ADR-GIZMO-LEVER-SPIN'
        }

        It 'leaves a numbered citation and a group as written and reports each Unhandled' {
            $text = 'ADR-WIDGET-GADGET' + '#3 and ADR-WIDGET-GADGET' + '#{1,2}'
            & $script:update 'notes/numbered.md' $text | Should -BeExactly $text
            @($script:changes.Kind) | Should -Be @([Catzc.Base.Drs.DrsCitationChangeKind]::Unhandled,
                [Catzc.Base.Drs.DrsCitationChangeKind]::Unhandled)
            @($script:changes.Old) | Should -Be @(('ADR-WIDGET-GADGET' + '#3'), ('ADR-WIDGET-GADGET' + '#{1,2}'))
            $script:changes[0].New | Should -BeNullOrEmpty
        }

        It 'matches a whole code and whole segments only' {
            & $script:update 'notes/boundary.md' 'ADR-WIDGET-GADGETS-FOLD ADR-WIDGET-GADGET-RE12 ADR-WIDGET-SPROCKET-SPINS xADR-WIDGET-GADGET-FOLD' |
                Should -BeExactly 'ADR-WIDGET-GADGETS-FOLD ADR-GIZMO-GADGET-RE12 ADR-WIDGET-SPROCKET-SPINS xADR-WIDGET-GADGET-FOLD'
        }

        It 'rewrites inside a fenced code block and an inline code span' {
            & $script:update 'notes/fenced.md' "``````text`nADR-WIDGET-SPROCKET-SPIN`n```````n``ADR-WIDGET-GADGET-TURN``" |
                Should -BeExactly "``````text`nADR-GIZMO-LEVER-SPIN`n```````n``ADR-GIZMO-GADGET-TURN``"
        }
    }

    Context 'codes and anchors' {
        It 'renames an ADR code and leaves a longer one alone' {
            & $script:update 'notes/code.md' 'ADR-WIDGET-GADGET, ADR-WIDGET-GADGETS, ADR-WIDGET-SPROCKET' |
                Should -BeExactly 'ADR-GIZMO-GADGET, ADR-WIDGET-GADGETS, ADR-WIDGET-SPROCKET'
        }

        It 'rewrites a standalone anchor through the rule map, then the code map' {
            & $script:update 'notes/anchor.md' 'rule-adr-widget-gadget-fold rule-adr-widget-sprocket-spin rule-adr-widget-sprocket-spins rule-adr-widget-gadget-lift' |
                Should -BeExactly 'rule-adr-gizmo-gadget-fold rule-adr-gizmo-lever-spin rule-adr-widget-sprocket-spins rule-adr-widget-sprocket-drop'
        }
    }

    Context 'links' {
        It 'resolves a relative link at the file''s own depth and writes it back relative' -Tag 'ADR-REPO-LINK-MARKDOWNRELATIVE' -ForEach @(
            @{ File = 'docs/drs/widget/near.md'; Link = 'sub/gadget-rules.md'; Expected = '../gizmo/gadget-rules.md' }
            @{ File = 'docs/drs/widget/sub/inside.md'; Link = 'gadget-rules.md'; Expected = '../../gizmo/gadget-rules.md' }
            @{ File = 'docs/guide/deep/far.md'; Link = '../../drs/widget/sub/gadget-rules.md'; Expected = '../../drs/gizmo/gadget-rules.md' }
            @{ File = 'top.md'; Link = 'docs/drs/widget/sub/cog-rules.md'; Expected = 'docs/drs/widget/cog-rules.md' }
            @{ File = 'docs/drs/widget/folder.md'; Link = 'sub/'; Expected = '../gizmo/' }
        ) {
            & $script:update $File "[x]($Link)" | Should -BeExactly "[x]($Expected)"
        }

        It 'follows a rule anchor to the file of the rule''s new ADR' -Tag 'ADR-REPO-LINK-MARKDOWNRELATIVE' {
            & $script:update 'docs/drs/widget/follow.md' '[s](sprocket-rules.md#rule-adr-widget-sprocket-spin) [g](sub/gadget-rules.md#rule-adr-widget-gadget-lift)' |
                Should -BeExactly '[s](../gizmo/lever-rules.md#rule-adr-gizmo-lever-spin) [g](sprocket-rules.md#rule-adr-widget-sprocket-drop)'
        }

        It 'sends an in-file anchor of a rule that leaves the ADR to the rule''s new file' {
            $text = "# Sprocket`n`n### Rule ADR-WIDGET-SPROCKET-TURN`n`nSee [spin](#rule-adr-widget-sprocket-spin) and [turn](#rule-adr-widget-sprocket-turn).`n"
            & $script:update 'docs/drs/widget/sprocket-rules.md' $text |
                Should -BeExactly "# Sprocket`n`n### Rule ADR-WIDGET-SPROCKET-TURN`n`nSee [spin](../gizmo/lever-rules.md#rule-adr-gizmo-lever-spin) and [turn](#rule-adr-widget-sprocket-turn).`n"
        }

        It 'keeps a code link repository-rooted, its text and target consistent' -Tag 'ADR-REPO-LINK-CODELINKS' {
            $text = "# [ADR-WIDGET-GADGET-FOLD](/docs/drs/widget/sub/gadget-rules.md#rule-adr-widget-gadget-fold)`n"
            & $script:update 'tools/Get-Widget.ps1' $text |
                Should -BeExactly "# [ADR-GIZMO-GADGET-FOLD](/docs/drs/gizmo/gadget-rules.md#rule-adr-gizmo-gadget-fold)`n"
        }

        It 'leaves an off-repository URL and an unmapped link alone' {
            $text = '[u](https://example.com/docs/adr/widget/sub/gadget-rules.md) [k](docs/adr/widget/sprocket-rules.md#rule-adr-widget-sprocket-turn)'
            & $script:update 'untouched-links.md' $text | Should -BeExactly $text
        }
    }

    Context 'plain paths' {
        It 'rewrites a path mention in each anchoring form' -ForEach @(
            @{ Text = 'docs/drs/widget/sub/gadget-rules.md.'; Expected = 'docs/drs/gizmo/gadget-rules.md.' }
            @{ Text = '`/docs/drs/widget/sub/cog-rules.md`'; Expected = '`/docs/drs/widget/cog-rules.md`' }
            @{ Text = 'widget/sub/cog-rules.md'; Expected = 'widget/cog-rules.md' }
            @{ Text = 'widget/sub/<name>.md'; Expected = 'gizmo/<name>.md' }
            @{ Text = 'folder: widget/sub'; Expected = 'folder: gizmo' }
            @{ Text = 'widget/sub/gadget-rules.md#rule-adr-widget-gadget-lift'; Expected = 'widget/sprocket-rules.md#rule-adr-widget-sprocket-drop' }
        ) {
            & $script:update 'docs/drs/plain.md' $Text | Should -BeExactly $Expected
        }

        It 'leaves a path that only ends like an ADR folder alone' {
            & $script:update 'docs/drs/plain-other.md' 'docs/guide/widget/sub/page.md and out/widget/sub' |
                Should -BeExactly 'docs/guide/widget/sub/page.md and out/widget/sub'
        }

        It 'moves a one-segment folder''s path mentions and leaves its bare name in prose alone' {
            $header = @('old_code', 'new_code', 'old_path', 'new_path', 'kind') -join "`t"
            $codeMap = & $script:writeText 'maps/folder-code-map.tsv' ($header + "`n" + (@('-', '-', 'gadgets/index.md',
                        'gizmos/index.md', 'folder') -join "`t") + "`n")
            & $script:writeText 'docs/drs/gadgets/index.md' "# Gadgets`n" | Out-Null
            $text = "Three gadgets share one fragment, so gadgets need a folder: gadgets/ holds them, see gadgets/index.md.`n"
            $full = & $script:writeText 'docs/drs/widget/folder-word.md' $text
            Update-DrsCitation -Path $full -CodeMap $codeMap -RuleMap $script:ruleMap -RepositoryRoot $script:root -InformationAction SilentlyContinue | Out-Null
            [System.IO.File]::ReadAllText($full) |
                Should -BeExactly "Three gadgets share one fragment, so gadgets need a folder: gizmos/ holds them, see gizmos/index.md.`n"
        }

        It 'leaves a path of a same-named folder outside docs/drs alone, such as a module path' {
            $header = @('old_code', 'new_code', 'old_path', 'new_path', 'kind') -join "`t"
            $codeMap = & $script:writeText 'maps/module-folder-code-map.tsv' ($header + "`n" + (@('-', '-',
                        "$(Split-Path (Get-CatzcModulesRoot) -Leaf)/index.md", 'automation/pwsh/index.md',
                        'folder') -join "`t") + "`n")
            $text = "The loader reads pwsh/Catzc.Widget/x.ps1 and pwsh/Catzc.Widget/ before any module.`n"
            $full = & $script:writeText 'docs/references/widget-loader.md' $text
            Update-DrsCitation -Path $full -CodeMap $codeMap -RuleMap $script:ruleMap -RepositoryRoot $script:root -InformationAction SilentlyContinue | Out-Null
            [System.IO.File]::ReadAllText($full) | Should -BeExactly $text
        }

        It 'inside docs/drs, moves a real page of the folder and leaves a module path of the same name alone' {
            $header = @('old_code', 'new_code', 'old_path', 'new_path', 'kind') -join "`t"
            $codeMap = & $script:writeText 'maps/module-folder-in-adr-code-map.tsv' ($header + "`n" + (@('-', '-',
                        "$(Split-Path (Get-CatzcModulesRoot) -Leaf)/index.md", 'automation/pwsh/index.md',
                        'folder') -join "`t") + "`n")
            & $script:writeText 'docs/drs/automation/pwsh/widget-rules.md' "# Widget rules`n" | Out-Null
            $text = "The loader reads pwsh/Catzc.Widget/x.ps1, and pwsh/widget-rules.md says why.`n"
            $full = & $script:writeText 'docs/drs/widget/module-paths.md' $text
            Update-DrsCitation -Path $full -CodeMap $codeMap -RuleMap $script:ruleMap -RepositoryRoot $script:root -InformationAction SilentlyContinue | Out-Null
            [System.IO.File]::ReadAllText($full) |
                Should -BeExactly "The loader reads pwsh/Catzc.Widget/x.ps1, and automation/pwsh/widget-rules.md says why.`n"
        }
    }

    Context 'a root move' -Tag 'ADR-REPO-LINK-MARKDOWNRELATIVE' {
        BeforeAll {
            $header = @('old_code', 'new_code', 'old_path', 'new_path', 'kind') -join "`t"
            $script:rootMap = & $script:writeText 'maps/root-code-map.tsv' ($header + "`n" + (@('-', '-', 'docs/drs',
                        'docs/gadgets', 'root') -join "`t") + "`n")
            $script:moveRoot = {
                param([string] $Relative, [string] $Text, [string] $CodeMap = $script:rootMap)
                $full = & $script:writeText $Relative $Text
                Update-DrsCitation -Path $full -CodeMap $CodeMap -RuleMap $script:ruleMap -RepositoryRoot $script:root -InformationAction SilentlyContinue |
                    Out-Null
                [System.IO.File]::ReadAllText($full)
            }
        }

        It 'moves a <Name> under the new root' -ForEach @(
            @{ Name = 'relative link from outside'; Relative = 'docs/how-to/widget.md'; Text = "See [cog](../drs/widget/cog-rules.md).`n"
                Expected = "See [cog](../gadgets/widget/cog-rules.md).`n"
            }
            @{ Name = 'repository-rooted code link'; Relative = 'docs/how-to/widget.md'; Text = "[cog](/docs/drs/widget/cog-rules.md#rule-adr-widget-cog-spins)`n"
                Expected = "[cog](/docs/gadgets/widget/cog-rules.md#rule-adr-widget-cog-spins)`n"
            }
            @{ Name = 'plain path mention'; Relative = 'notes/widget.md'; Text = "Read docs/drs/gizmo/lever-rules.md first.`n"
                Expected = "Read docs/gadgets/gizmo/lever-rules.md first.`n"
            }
            @{ Name = 'bare mention of the root itself'; Relative = 'notes/widget.md'; Text = "Records live in docs/drs/, see /docs/drs. Root: 'docs/drs'`n"
                Expected = "Records live in docs/gadgets/, see /docs/gadgets. Root: 'docs/gadgets'`n"
            }
        ) {
            & $script:moveRoot $Relative $Text | Should -BeExactly $Expected
        }

        It 'leaves a longer path that only contains the root alone' {
            $text = "See site/docs/adr and docs/adrs and docs/adr-notes.`n"
            & $script:moveRoot 'notes/longer.md' $text | Should -BeExactly $text
        }

        It 'leaves a link between two records, and a link out of the root at the same depth, as written' {
            $text = "[lever](../gizmo/lever-rules.md) and [how-to](../../how-to/widget.md) and [here](#rule-adr-widget-sprocket-turn)`n"
            & $script:moveRoot 'docs/drs/widget/root-links.md' $text | Should -BeExactly $text
        }

        It 'refuses a root row that <Name>' -ForEach @(
            @{ Name = 'moves another folder'; From = 'docs/gizmos'; To = 'docs/gadgets'; Error = "*moves the root 'docs/drs', not 'docs/gizmos'*" }
            @{ Name = 'changes the depth'; From = 'docs/drs'; To = 'gadgets'; Error = '*not a folder of its own depth*' }
        ) {
            $header = @('old_code', 'new_code', 'old_path', 'new_path', 'kind') -join "`t"
            $codeMap = & $script:writeText "maps/bad-root-$($From -replace '/', '-').tsv" ($header + "`n" + (@('-', '-',
                        $From, $To, 'root') -join "`t") + "`n")
            { & $script:moveRoot 'notes/refused.md' "text`n" $codeMap } | Should -Throw $Error
        }
    }

    Context 'the file' {
        It 'returns each change with its kind, line, old text, and new text' {
            & $script:update 'docs/drs/widget/report.md' "ADR-WIDGET-GADGET-LIFT`n[c](sub/cog-rules.md) ADR-WIDGET-GADGET`n" | Out-Null
            $script:changes.Count | Should -Be 3
            $script:changes[0].Kind | Should -Be ([Catzc.Base.Drs.DrsCitationChangeKind]::Citation)
            $script:changes[0].Line | Should -Be 1
            $script:changes[0].Old | Should -BeExactly 'ADR-WIDGET-GADGET-LIFT'
            $script:changes[0].New | Should -BeExactly 'ADR-WIDGET-SPROCKET-DROP'
            $script:changes[1].Kind | Should -Be ([Catzc.Base.Drs.DrsCitationChangeKind]::Link)
            $script:changes[1].Line | Should -Be 2
            $script:changes[1].New | Should -BeExactly 'cog-rules.md'
            $script:changes[2].Kind | Should -Be ([Catzc.Base.Drs.DrsCitationChangeKind]::Code)
            $script:changes[2].Path | Should -BeExactly 'docs/drs/widget/report.md'
        }

        It 'with -DryRun returns the changes and writes nothing' -Tag 'ADR-AUTO-DRYRUN-BRANCHBEFORESIDEEFFECT' {
            $full = & $script:writeText 'dry/run.md' 'ADR-WIDGET-GADGET-FOLD'
            $before = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($full))
            $changes = @(Update-DrsCitation -Path $full -CodeMap $script:codeMap -RuleMap $script:ruleMap -RepositoryRoot $script:root -DryRun)
            $changes.Count | Should -Be 1
            $changes[0].New | Should -BeExactly 'ADR-GIZMO-GADGET-FOLD'
            [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($full)) | Should -BeExactly $before
        }

        It 'leaves a file with nothing to change byte-identical, with CRLF and a byte order mark' {
            $body = $script:utf8.GetBytes("ADR-WIDGET-SPROCKET-TURN`r`n[k](../widget/cog-rules.md)`r`n")
            $full = & $script:writeBytes 'docs/drs/gizmo/still.md' ([byte[]] (@(0xEF, 0xBB, 0xBF) + $body))
            $before = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($full))
            $stamp = [System.IO.File]::GetLastWriteTimeUtc($full)
            $changes = @(Update-DrsCitation -Path $full -CodeMap $script:codeMap -RuleMap $script:ruleMap -RepositoryRoot $script:root)
            $changes.Count | Should -Be 0
            [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($full)) | Should -BeExactly $before
            [System.IO.File]::GetLastWriteTimeUtc($full) | Should -Be $stamp
        }

        It 'keeps the byte order mark, CRLF line endings, and the trailing newline of a changed file' {
            $body = $script:utf8.GetBytes("ADR-WIDGET-GADGET-FOLD`r`n- a widget`r`n")
            $full = & $script:writeBytes 'docs/bom.md' ([byte[]] (@(0xEF, 0xBB, 0xBF) + $body))
            Update-DrsCitation -Path $full -CodeMap $script:codeMap -RuleMap $script:ruleMap -RepositoryRoot $script:root | Out-Null
            $expected = [System.Convert]::ToBase64String([byte[]] (@(0xEF, 0xBB,
                        0xBF) + $script:utf8.GetBytes("ADR-GIZMO-GADGET-FOLD`r`n- a widget`r`n")))
            [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($full)) | Should -BeExactly $expected
        }

        It 'is a no-op the second time' -Tag 'ADR-AUTO-IDEM-CHECKBEFOREACTING' {
            $text = "ADR-WIDGET-GADGET-TURN, ADR-WIDGET-GADGET-LIFT`n[s](../widget/sprocket-rules.md#rule-adr-widget-sprocket-spin) widget/sub/`n"
            $once = & $script:update 'docs/drs/gizmo/twice.md' $text
            $once | Should -Not -BeExactly $text
            $full = Join-Path $script:root 'docs/drs/gizmo/twice.md'
            $again = @(Update-DrsCitation -Path $full -CodeMap $script:codeMap -RuleMap $script:ruleMap -RepositoryRoot $script:root)
            $again.Count | Should -Be 0
            [System.IO.File]::ReadAllText($full) | Should -BeExactly $once
        }
    }

    Context 'inputs' {
        It 'fails on a file that does not exist' {
            { Update-DrsCitation -Path (Join-Path $script:root 'missing.md') -CodeMap $script:codeMap -RuleMap $script:ruleMap -RepositoryRoot $script:root } |
                Should -Throw '*missing.md*'
        }

        It 'fails on a file outside the repository root' {
            $outside = Join-Path $TestDrive 'outside.md'
            [System.IO.File]::WriteAllText($outside, 'text')
            { Update-DrsCitation -Path $outside -CodeMap $script:codeMap -RuleMap $script:ruleMap -RepositoryRoot $script:root } |
                Should -Throw '*outside the repository root*'
        }

        It 'fails on a map whose header is not the expected one' {
            $full = & $script:writeText 'maps/bad-code-map.tsv' ((@('old',
                        'new') -join "`t") + "`n" + (@('ADR-WIDGET-GADGET', 'ADR-GIZMO-GADGET') -join "`t") + "`n")
            $target = & $script:writeText 'maps/target.md' 'text'
            { Update-DrsCitation -Path $target -CodeMap $full -RuleMap $script:ruleMap -RepositoryRoot $script:root } |
                Should -Throw '*header*'
        }

        It 'fails on a rule map row that is not <Name>' -ForEach @(
            @{ Name = 'a rule code on both sides, as a numbered rule is not'; Old = ('ADR-WIDGET-GADGET' + '#4'); New = 'ADR-WIDGET-SPROCKET-DROP'; Kind = 'collapse'; Expected = '*is not a rule code -> a rule code*' }
            @{ Name = 'upper case'; Old = 'ADR-WIDGET-COG-TURNS'; New = 'ADR-WIDGET-COG-turns'; Kind = 'move'; Expected = '*is not a rule code -> a rule code*' }
            @{ Name = 'of a kind the map knows'; Old = 'ADR-WIDGET-COG-TURNS'; New = 'ADR-WIDGET-COG-SPINS'; Kind = 'name'; Expected = '*is not one of move, collapse*' }
        ) {
            $rows = @(
                @('old_rule', 'new_rule', 'kind', 'why') -join "`t"
                @($Old, $New, $Kind, 'a malformed row') -join "`t"
            )
            $full = & $script:writeText "maps/bad-rule-map-$([guid]::NewGuid().ToString('N')).tsv" (($rows -join "`n") + "`n")
            $target = & $script:writeText 'maps/target-rule.md' 'text'
            { Update-DrsCitation -Path $target -CodeMap $script:codeMap -RuleMap $full -RepositoryRoot $script:root } |
                Should -Throw $Expected
        }
    }

    Context 'the citation form, by the line''s width' -Tag 'ADR-REPO-LINK-ONECITATIONSPELLING' {
        BeforeAll {
            $script:pad = 'widget ' * 12
            $script:inline = '([ADR-WIDGET-COG-TURNS](../docs/drs/widget/cog-rules.md#rule-adr-widget-cog-turns))'
            $script:target = '../docs/drs/widget/cog-rules.md#rule-adr-widget-cog-spins'
        }

        It 'respells a citation as a reference r1 when its rewritten line outgrows the width, its definition at the end' {
            $result = & $script:update 'notes/wide.md' "# Wide`n`n$script:pad$script:inline.`n"
            $result | Should -BeExactly "# Wide`n`n$script:pad([ADR-WIDGET-COG-SPINS][r1]).`n`n[r1]: $script:target`n"
            @($script:changes | Where-Object Kind -EQ ([Catzc.Base.Drs.DrsCitationChangeKind]::Form)).Count |
                Should -Be 1
        }

        It 'keeps a citation inline when its line fits' {
            & $script:update 'notes/narrow.md' "See $script:inline.`n" |
                Should -BeExactly "See ([ADR-WIDGET-COG-SPINS]($script:target)).`n"
        }

        It 'never changes the form in a code file' {
            $line = "# $script:pad$script:pad [ADR-WIDGET-COG-TURNS](/docs/drs/widget/cog-rules.md#rule-adr-widget-cog-turns)"
            (& $script:update 'src/wide.ps1' $line).Contains('][r') | Should -BeFalse
        }

        It 'reuses the label of a definition that already names the same destination' {
            $result = & $script:update 'notes/defined.md' "$script:pad$script:inline.`n`n[r4]: $script:target`n"
            ([regex]::Matches($result, '(?m)^\[r\d+\]:')).Count | Should -Be 1
            $result.Contains('([ADR-WIDGET-COG-SPINS][r4]).') | Should -BeTrue
        }

        It 'keeps every existing label''s number and gives a new destination the next free one' {
            $result = & $script:update 'notes/stable.md' "$script:pad$script:inline.`n`n[r1]: ../docs/drs/index.md`n[r2]: ../docs/drs/widget/sprocket-rules.md`n"
            $result.Contains("[r1]: ../docs/drs/index.md`n[r2]: ../docs/drs/widget/sprocket-rules.md`n[r3]: $script:target`n") | Should -BeTrue
            $result.Contains('([ADR-WIDGET-COG-SPINS][r3]).') | Should -BeTrue
        }
    }

    Context 'rule renames' -Tag 'ADR-REPO-DRSCODE-NAMEDNOTNUMBERED' {
        It 'renames a rule in place, its citation and its heading' {
            & $script:update 'notes/renamed.md' "See ADR-WIDGET-COG-TURNS.`n### Rule ADR-WIDGET-COG-TURNS`n" |
                Should -BeExactly "See ADR-WIDGET-COG-SPINS.`n### Rule ADR-WIDGET-COG-SPINS`n"
        }

        It 'rewrites a code link''s text and its anchor to the renamed rule' -Tag 'ADR-REPO-LINK-CODELINKS' {
            & $script:update 'src/renamed.ps1' '# [ADR-WIDGET-COG-TURNS](/docs/drs/widget/cog-rules.md#rule-adr-widget-cog-turns)' |
                Should -BeExactly '# [ADR-WIDGET-COG-SPINS](/docs/drs/widget/cog-rules.md#rule-adr-widget-cog-spins)'
        }

        It 'reports a numbered heading as Unhandled and leaves it as written' {
            $text = '### Rule ADR-WIDGET-COG' + ":2`n"
            & $script:update 'notes/numbered-heading.md' $text | Should -BeExactly $text
            @($script:changes.Kind) | Should -Be @([Catzc.Base.Drs.DrsCitationChangeKind]::Unhandled)
        }
    }
}
