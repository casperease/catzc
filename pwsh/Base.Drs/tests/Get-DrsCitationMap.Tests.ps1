Describe 'Get-DrsCitationMap' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $write = {
            param([string] $Relative, [string[]] $Lines)
            $full = Join-Path $script:root $Relative
            [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($full, ($Lines -join "`n"))
        }
        & $write 'docs/drs/index.md' @(
            '| Code | Record |'
            '| ---- | ------ |'
            '| `ADR-TST-WIDGET` | [widget-rules](widget/widget-rules.md) |'
            '| `ADR-TST-GADGET` | [gadget-rules](gadget/gadget-rules.md) |'
        )
        & $write 'docs/drs/widget/widget-rules.md' @('# Widget', '', '### Rule ADR-TST-WIDGET-TURN', '', 'One.', '',
            '### Rule ADR-TST-WIDGET-RE02', '', 'Two.')
        & $write 'docs/drs/gadget/gadget-rules.md' @('# Gadget', '', '### Rule ADR-TST-GADGET-FOLD', '', 'One.')
        & $write 'docs/drs/widget/widget-notes.md' @('# Widget notes')
        & $write 'docs/drs/gadget/widget-notes.md' @('# Gadget notes')
        $script:map = Get-DrsCitationMap -RepositoryRoot $script:root
    }

    It 'maps each code to its repository-relative record path and declared rules' -Tag 'ADR-REPO-LINK-CODELINKS' {
        $map.PathOf('ADR-TST-WIDGET') | Should -BeExactly 'docs/drs/widget/widget-rules.md'
        $map.RulesOf('ADR-TST-WIDGET') | Should -Be @('ADR-TST-WIDGET-TURN', 'ADR-TST-WIDGET-RE02')
        $map.IsRule('ADR-TST-WIDGET-RE02') | Should -BeTrue
        $map.IsRule('ADR-TST-WIDGET-SPIN') | Should -BeFalse
        $map.RecordOf('ADR-TST-WIDGET-RE02') | Should -BeExactly 'ADR-TST-WIDGET'
        $map.PathOf('ADR-TST-WIDGET-RE02') | Should -BeExactly 'docs/drs/widget/widget-rules.md'
        $map.CodeOf('docs/drs/gadget/gadget-rules.md') | Should -BeExactly 'ADR-TST-GADGET'
    }

    It 'derives the repository-rooted destination from the citation' -Tag 'ADR-REPO-LINK-CODELINKS' {
        $map.Destination('ADR-TST-WIDGET-RE02') |
            Should -BeExactly '/docs/drs/widget/widget-rules.md#rule-adr-tst-widget-re02'
        $map.Destination('ADR-TST-GADGET') | Should -BeExactly '/docs/drs/gadget/gadget-rules.md'
    }

    It 'reads a rule heading anchor back as its rule, and names the parent record of an undeclared rule' -Tag 'ADR-REPO-LINK-CODELINKS' {
        $map.RuleOfAnchor('ADR-TST-WIDGET', '#rule-adr-tst-widget-turn') | Should -BeExactly 'ADR-TST-WIDGET-TURN'
        $map.RuleOfAnchor('ADR-TST-WIDGET', '#rule-adr-tst-widget1') | Should -BeNullOrEmpty
        $map.ParentRecord('ADR-TST-WIDGET-SPIN') | Should -BeExactly 'ADR-TST-WIDGET'
        $map.ParentRecord('ADR-TST-SPROCKET-SPIN') | Should -BeNullOrEmpty
    }

    It 'knows the domain prefix of its codes and rejects an unknown code' -Tag 'ADR-REPO-LINK-ONECITATIONSPELLING' {
        $map.IsDomainCode('ADR-TST') | Should -BeTrue
        $map.HasCode('ADR-TST-SPROCKET') | Should -BeFalse
    }

    It 'reads the index, the records and the document list from the active source, memoized apart from the working tree''s' {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Repository { $script:root }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Drs { $script:root }
        $commit = @{
            Name = 'c' * 40
            Path = [string[]] @('docs/drs/index.md', 'docs/drs/sprocket/sprocket-rules.md', 'docs/drs/widget/widget-rules.md')
            Text = @{
                'docs/drs/index.md'                   = "| Code | Record |`n| ---- | ------ |`n| ``ADR-TST-SPROCKET`` | [sprocket-rules](sprocket/sprocket-rules.md) |`n"
                'docs/drs/sprocket/sprocket-rules.md' = "# Sprocket`n`n### Rule ADR-TST-SPROCKET-SPIN`n`nOne.`n"
            }
        }
        $committed = Use-RepositoryTextSource @commit -ScriptBlock { Get-DrsCitationMap -RepositoryRoot $script:root }
        $committed.HasCode('ADR-TST-SPROCKET') | Should -BeTrue
        $committed.HasCode('ADR-TST-WIDGET') | Should -BeFalse -Because 'the working tree''s index is not the commit''s'
        $committed.RulesOf('ADR-TST-SPROCKET') | Should -Be @('ADR-TST-SPROCKET-SPIN')
        $committed.IsDocument('docs/drs/widget/widget-rules.md') | Should -BeTrue
        $committed.IsDocument('docs/drs/gadget/gadget-rules.md') | Should -BeFalse
        (Get-DrsCitationMap -RepositoryRoot $script:root).HasCode('ADR-TST-WIDGET') | Should -BeTrue
    }

    It 'resolves a unique file name and refuses an ambiguous one' -Tag 'ADR-REPO-LINK-CODELINKS' {
        $map.PathOfSlug('gadget-rules') | Should -BeExactly 'docs/drs/gadget/gadget-rules.md'
        $map.PathOfSlug('widget-notes') | Should -BeNullOrEmpty
        $map.IsAmbiguousSlug('widget-notes') | Should -BeTrue
        $map.IsDocument('docs/drs/gadget/widget-notes.md') | Should -BeTrue
    }
}
