<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/Update-AdrCitation.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-base-docs/tests/Update-AdrCitation.Tests.ps1.md
      source: automation/Catzc.Base.Docs/Update-AdrCitation.ps1
    adrs:
      - ADR-AUTO-DRYRUN#2
      - ADR-AUTO-IDEM#1
      - ADR-AUTO-TEST#3
      - ADR-REPO-LINK#{2,3}
---
#>

Describe 'Update-AdrCitation' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $assets = Join-Path $PSScriptRoot 'assets/update-adr-citation'
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
            $script:changes = @(Update-AdrCitation -Path $full -CodeMap $script:codeMap -RuleMap $script:ruleMap -RepositoryRoot $script:root -InformationAction SilentlyContinue)
            [System.IO.File]::ReadAllText($full)
        }

        & $script:writeText 'docs/adr/index.md' ((@(
                    '| Code | ADR |'
                    '| ---- | --- |'
                    '| `ADR-WIDGET-SPROCKET` | [sprocket-rules](widget/sprocket-rules.md) |'
                    '| `ADR-WIDGET-COG` | [cog-rules](widget/cog-rules.md) |'
                    '| `ADR-GIZMO-GADGET` | [gadget-rules](gizmo/gadget-rules.md) |'
                    '| `ADR-GIZMO-LEVER` | [lever-rules](gizmo/lever-rules.md) |'
                ) -join "`n") + "`n") | Out-Null
        & $script:writeText 'docs/adr/widget/sprocket-rules.md' "# Sprocket`n`n### Rule ADR-WIDGET-SPROCKET:1`n`nOne.`n" | Out-Null
        & $script:writeText 'docs/adr/widget/cog-rules.md' "# Cog`n`n### Rule ADR-WIDGET-COG:1`n`nOne.`n" | Out-Null
        & $script:writeText 'docs/adr/gizmo/gadget-rules.md' "# Gadget`n`n### Rule ADR-GIZMO-GADGET:1`n`nOne.`n" | Out-Null
        & $script:writeText 'docs/adr/gizmo/lever-rules.md' "# Lever`n`n### Rule ADR-GIZMO-LEVER:1`n`nOne.`n" | Out-Null
    }

    Context 'citations' {
        It 'renames a citation and the heading''s colon form through the code map, keeping each spelling' {
            & $script:update 'notes/rename.md' "See ADR-WIDGET-GADGET#3.`n### Rule ADR-WIDGET-GADGET:3`n" |
                Should -BeExactly "See ADR-GIZMO-GADGET#3.`n### Rule ADR-GIZMO-GADGET:3`n"
        }

        It 'sends a moved rule and a collapsed rule where the rule map says' {
            & $script:update 'notes/moved.md' 'ADR-WIDGET-SPROCKET#5 and ADR-WIDGET-GADGET#4' |
                Should -BeExactly 'ADR-GIZMO-LEVER#1 and ADR-WIDGET-SPROCKET#9'
        }

        It 'keeps a list continuation bare while its rules keep the code' {
            & $script:update 'notes/list.md' 'ADR-WIDGET-GADGET#1, #3 and #7' | Should -BeExactly 'ADR-GIZMO-GADGET#1, #3 and #7'
        }

        It 'gives an inherited rule its own code when it moves, and the next one the code it returns to' {
            & $script:update 'notes/list-split.md' 'ADR-WIDGET-GADGET#1, #4 and #7; ADR-WIDGET-SPROCKET#5/#6' |
                Should -BeExactly 'ADR-GIZMO-GADGET#1, ADR-WIDGET-SPROCKET#9 and ADR-GIZMO-GADGET#7; ADR-GIZMO-LEVER#1/ADR-WIDGET-SPROCKET#6'
        }

        It 'carries a list continuation across a wrapped line' {
            & $script:update 'notes/list-wrapped.md' "ADR-WIDGET-GADGET#1, #3 and`n#7" | Should -BeExactly "ADR-GIZMO-GADGET#1, #3 and`n#7"
        }

        It 'renames a range whose rules all keep their numbers' {
            & $script:update 'notes/range.md' 'ADR-WIDGET-GADGET#5 to #8' | Should -BeExactly 'ADR-GIZMO-GADGET#5 to #8'
        }

        It 'leaves a range that spans a moved rule as written and reports it Unhandled' {
            & $script:update 'notes/range-split.md' 'ADR-WIDGET-GADGET#1 to #6' | Should -BeExactly 'ADR-WIDGET-GADGET#1 to #6'
            $script:changes.Count | Should -Be 1
            $script:changes[0].Kind | Should -Be ([Catzc.Base.Docs.AdrCitationChangeKind]::Unhandled)
            $script:changes[0].Old | Should -BeExactly 'ADR-WIDGET-GADGET#1 to #6'
            $script:changes[0].New | Should -BeNullOrEmpty
        }

        It 'matches a whole code and a whole rule number only' {
            & $script:update 'notes/boundary.md' 'ADR-WIDGET-GADGETS#3 ADR-WIDGET-GADGET#12 ADR-WIDGET-SPROCKET#50 xADR-WIDGET-GADGET#3' |
                Should -BeExactly 'ADR-WIDGET-GADGETS#3 ADR-GIZMO-GADGET#12 ADR-WIDGET-SPROCKET#50 xADR-WIDGET-GADGET#3'
        }

        It 'rewrites inside a fenced code block and an inline code span' {
            & $script:update 'notes/fenced.md' "``````text`nADR-WIDGET-SPROCKET#5`n```````n``ADR-WIDGET-GADGET#2``" |
                Should -BeExactly "``````text`nADR-GIZMO-LEVER#1`n```````n``ADR-GIZMO-GADGET#2``"
        }
    }

    Context 'codes and anchors' {
        It 'renames a bare code and leaves a longer one alone' {
            & $script:update 'notes/code.md' 'ADR-WIDGET-GADGET, ADR-WIDGET-GADGETS, ADR-WIDGET-SPROCKET' |
                Should -BeExactly 'ADR-GIZMO-GADGET, ADR-WIDGET-GADGETS, ADR-WIDGET-SPROCKET'
        }

        It 'rewrites a standalone anchor through the rule map, then the code map' {
            & $script:update 'notes/anchor.md' 'rule-adr-widget-gadget3 rule-adr-widget-sprocket5 rule-adr-widget-sprocket50 rule-adr-widget-gadget4' |
                Should -BeExactly 'rule-adr-gizmo-gadget3 rule-adr-gizmo-lever1 rule-adr-widget-sprocket50 rule-adr-widget-sprocket9'
        }
    }

    Context 'links' {
        It 'resolves a relative link at the file''s own depth and writes it back relative' -Tag 'ADR-REPO-LINK#2' -ForEach @(
            @{ File = 'docs/adr/widget/near.md'; Link = 'sub/gadget-rules.md'; Expected = '../gizmo/gadget-rules.md' }
            @{ File = 'docs/adr/widget/sub/inside.md'; Link = 'gadget-rules.md'; Expected = '../../gizmo/gadget-rules.md' }
            @{ File = 'docs/guide/deep/far.md'; Link = '../../adr/widget/sub/gadget-rules.md'; Expected = '../../adr/gizmo/gadget-rules.md' }
            @{ File = 'top.md'; Link = 'docs/adr/widget/sub/cog-rules.md'; Expected = 'docs/adr/widget/cog-rules.md' }
            @{ File = 'docs/adr/widget/folder.md'; Link = 'sub/'; Expected = '../gizmo/' }
        ) {
            & $script:update $File "[x]($Link)" | Should -BeExactly "[x]($Expected)"
        }

        It 'follows a rule anchor to the file of the rule''s new ADR' -Tag 'ADR-REPO-LINK#2' {
            & $script:update 'docs/adr/widget/follow.md' '[s](sprocket-rules.md#rule-adr-widget-sprocket5) [g](sub/gadget-rules.md#rule-adr-widget-gadget4)' |
                Should -BeExactly '[s](../gizmo/lever-rules.md#rule-adr-gizmo-lever1) [g](sprocket-rules.md#rule-adr-widget-sprocket9)'
        }

        It 'sends an in-file anchor of a rule that leaves the ADR to the rule''s new file' {
            $text = "# Sprocket`n`n### Rule ADR-WIDGET-SPROCKET:1`n`nSee [five](#rule-adr-widget-sprocket5) and [one](#rule-adr-widget-sprocket1).`n"
            & $script:update 'docs/adr/widget/sprocket-rules.md' $text |
                Should -BeExactly "# Sprocket`n`n### Rule ADR-WIDGET-SPROCKET:1`n`nSee [five](../gizmo/lever-rules.md#rule-adr-gizmo-lever1) and [one](#rule-adr-widget-sprocket1).`n"
        }

        It 'keeps a code link repository-rooted, its text and target consistent' -Tag 'ADR-REPO-LINK#3' {
            $text = "# [ADR-WIDGET-GADGET#3](/docs/adr/widget/sub/gadget-rules.md#rule-adr-widget-gadget3)`n"
            & $script:update 'tools/Get-Widget.ps1' $text |
                Should -BeExactly "# [ADR-GIZMO-GADGET#3](/docs/adr/gizmo/gadget-rules.md#rule-adr-gizmo-gadget3)`n"
        }

        It 'leaves an off-repository URL and an unmapped link alone' {
            $text = '[u](https://example.com/docs/adr/widget/sub/gadget-rules.md) [k](docs/adr/widget/sprocket-rules.md#rule-adr-widget-sprocket1)'
            & $script:update 'untouched-links.md' $text | Should -BeExactly $text
        }
    }

    Context 'plain paths' {
        It 'rewrites a path mention in each anchoring form' -ForEach @(
            @{ Text = 'docs/adr/widget/sub/gadget-rules.md.'; Expected = 'docs/adr/gizmo/gadget-rules.md.' }
            @{ Text = '`/docs/adr/widget/sub/cog-rules.md`'; Expected = '`/docs/adr/widget/cog-rules.md`' }
            @{ Text = 'widget/sub/cog-rules.md'; Expected = 'widget/cog-rules.md' }
            @{ Text = 'widget/sub/<name>.md'; Expected = 'gizmo/<name>.md' }
            @{ Text = 'folder: widget/sub'; Expected = 'folder: gizmo' }
            @{ Text = 'widget/sub/gadget-rules.md#rule-adr-widget-gadget4'; Expected = 'widget/sprocket-rules.md#rule-adr-widget-sprocket9' }
        ) {
            & $script:update 'docs/adr/plain.md' $Text | Should -BeExactly $Expected
        }

        It 'leaves a path that only ends like an ADR folder alone' {
            & $script:update 'docs/adr/plain-other.md' 'docs/guide/widget/sub/page.md and out/widget/sub' |
                Should -BeExactly 'docs/guide/widget/sub/page.md and out/widget/sub'
        }
    }

    Context 'the file' {
        It 'returns each change with its kind, line, old text, and new text' {
            & $script:update 'docs/adr/widget/report.md' "ADR-WIDGET-GADGET#3`n[c](sub/cog-rules.md) ADR-WIDGET-GADGET`n" | Out-Null
            $script:changes.Count | Should -Be 3
            $script:changes[0].Kind | Should -Be ([Catzc.Base.Docs.AdrCitationChangeKind]::Citation)
            $script:changes[0].Line | Should -Be 1
            $script:changes[0].Old | Should -BeExactly 'ADR-WIDGET-GADGET#3'
            $script:changes[0].New | Should -BeExactly 'ADR-GIZMO-GADGET#3'
            $script:changes[1].Kind | Should -Be ([Catzc.Base.Docs.AdrCitationChangeKind]::Link)
            $script:changes[1].Line | Should -Be 2
            $script:changes[1].New | Should -BeExactly 'cog-rules.md'
            $script:changes[2].Kind | Should -Be ([Catzc.Base.Docs.AdrCitationChangeKind]::Code)
            $script:changes[2].Path | Should -BeExactly 'docs/adr/widget/report.md'
        }

        It 'with -DryRun returns the changes and writes nothing' -Tag 'ADR-AUTO-DRYRUN#2' {
            $full = & $script:writeText 'dry/run.md' 'ADR-WIDGET-GADGET#3'
            $before = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($full))
            $changes = @(Update-AdrCitation -Path $full -CodeMap $script:codeMap -RuleMap $script:ruleMap -RepositoryRoot $script:root -DryRun)
            $changes.Count | Should -Be 1
            $changes[0].New | Should -BeExactly 'ADR-GIZMO-GADGET#3'
            [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($full)) | Should -BeExactly $before
        }

        It 'leaves a file with nothing to change byte-identical, with CRLF and a byte order mark' {
            $body = $script:utf8.GetBytes("ADR-WIDGET-SPROCKET#1`r`n[k](../widget/cog-rules.md)`r`n")
            $full = & $script:writeBytes 'docs/adr/gizmo/still.md' ([byte[]] (@(0xEF, 0xBB, 0xBF) + $body))
            $before = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($full))
            $stamp = [System.IO.File]::GetLastWriteTimeUtc($full)
            $changes = @(Update-AdrCitation -Path $full -CodeMap $script:codeMap -RuleMap $script:ruleMap -RepositoryRoot $script:root)
            $changes.Count | Should -Be 0
            [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($full)) | Should -BeExactly $before
            [System.IO.File]::GetLastWriteTimeUtc($full) | Should -Be $stamp
        }

        It 'keeps the byte order mark, CRLF line endings, and the trailing newline of a changed file' {
            $body = $script:utf8.GetBytes("ADR-WIDGET-GADGET#3`r`n- a widget`r`n")
            $full = & $script:writeBytes 'docs/bom.md' ([byte[]] (@(0xEF, 0xBB, 0xBF) + $body))
            Update-AdrCitation -Path $full -CodeMap $script:codeMap -RuleMap $script:ruleMap -RepositoryRoot $script:root | Out-Null
            $expected = [System.Convert]::ToBase64String([byte[]] (@(0xEF, 0xBB, 0xBF) + $script:utf8.GetBytes("ADR-GIZMO-GADGET#3`r`n- a widget`r`n")))
            [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($full)) | Should -BeExactly $expected
        }

        It 'is a no-op the second time' -Tag 'ADR-AUTO-IDEM#1' {
            $text = "ADR-WIDGET-GADGET#1, #4 and #7`n[s](../widget/sprocket-rules.md#rule-adr-widget-sprocket5) widget/sub/`n"
            $once = & $script:update 'docs/adr/gizmo/twice.md' $text
            $once | Should -Not -BeExactly $text
            $full = Join-Path $script:root 'docs/adr/gizmo/twice.md'
            $again = @(Update-AdrCitation -Path $full -CodeMap $script:codeMap -RuleMap $script:ruleMap -RepositoryRoot $script:root)
            $again.Count | Should -Be 0
            [System.IO.File]::ReadAllText($full) | Should -BeExactly $once
        }
    }

    Context 'inputs' {
        It 'fails on a file that does not exist' {
            { Update-AdrCitation -Path (Join-Path $script:root 'missing.md') -CodeMap $script:codeMap -RuleMap $script:ruleMap -RepositoryRoot $script:root } |
                Should -Throw '*missing.md*'
        }

        It 'fails on a file outside the repository root' {
            $outside = Join-Path $TestDrive 'outside.md'
            [System.IO.File]::WriteAllText($outside, 'text')
            { Update-AdrCitation -Path $outside -CodeMap $script:codeMap -RuleMap $script:ruleMap -RepositoryRoot $script:root } |
                Should -Throw '*outside the repository root*'
        }

        It 'fails on a map whose header is not the expected one' {
            $full = & $script:writeText 'maps/bad-code-map.tsv' ((@('old', 'new') -join "`t") + "`n" + (@('ADR-WIDGET-GADGET', 'ADR-GIZMO-GADGET') -join "`t") + "`n")
            $target = & $script:writeText 'maps/target.md' 'text'
            { Update-AdrCitation -Path $target -CodeMap $full -RuleMap $script:ruleMap -RepositoryRoot $script:root } |
                Should -Throw '*header*'
        }

        It 'fails on a rule map row that is not spelled with the colon' {
            $rows = @(
                @('old_rule', 'new_rule', 'kind', 'why') -join "`t"
                @('ADR-WIDGET-GADGET#4', 'ADR-WIDGET-SPROCKET:9', 'collapse', 'a hash, not a colon') -join "`t"
            )
            $full = & $script:writeText 'maps/bad-rule-map.tsv' (($rows -join "`n") + "`n")
            $target = & $script:writeText 'maps/target-rule.md' 'text'
            { Update-AdrCitation -Path $target -CodeMap $script:codeMap -RuleMap $full -RepositoryRoot $script:root } |
                Should -Throw '*rule map*'
        }
    }
}
