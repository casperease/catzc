<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-drs/tests/Get-DrsCitationMap.Tests.ps1.md"
  header: "generated"
---
#>

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
            '| Code | ADR |'
            '| ---- | --- |'
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

    It 'maps each code to its repository-relative ADR path and declared rules' -Tag 'ADR-REPO-LINK-CODELINKS' {
        $map.PathOf('ADR-TST-WIDGET') | Should -BeExactly 'docs/drs/widget/widget-rules.md'
        $map.RulesOf('ADR-TST-WIDGET') | Should -Be @('ADR-TST-WIDGET-TURN', 'ADR-TST-WIDGET-RE02')
        $map.IsRule('ADR-TST-WIDGET-RE02') | Should -BeTrue
        $map.IsRule('ADR-TST-WIDGET-SPIN') | Should -BeFalse
        $map.AdrOf('ADR-TST-WIDGET-RE02') | Should -BeExactly 'ADR-TST-WIDGET'
        $map.PathOf('ADR-TST-WIDGET-RE02') | Should -BeExactly 'docs/drs/widget/widget-rules.md'
        $map.CodeOf('docs/drs/gadget/gadget-rules.md') | Should -BeExactly 'ADR-TST-GADGET'
    }

    It 'derives the repository-rooted destination from the citation' -Tag 'ADR-REPO-LINK-CODELINKS' {
        $map.Destination('ADR-TST-WIDGET-RE02') |
            Should -BeExactly '/docs/drs/widget/widget-rules.md#rule-adr-tst-widget-re02'
        $map.Destination('ADR-TST-GADGET') | Should -BeExactly '/docs/drs/gadget/gadget-rules.md'
    }

    It 'reads a rule heading anchor back as its rule, and names the parent ADR of an undeclared rule' -Tag 'ADR-REPO-LINK-CODELINKS' {
        $map.RuleOfAnchor('ADR-TST-WIDGET', '#rule-adr-tst-widget-turn') | Should -BeExactly 'ADR-TST-WIDGET-TURN'
        $map.RuleOfAnchor('ADR-TST-WIDGET', '#rule-adr-tst-widget1') | Should -BeNullOrEmpty
        $map.ParentAdr('ADR-TST-WIDGET-SPIN') | Should -BeExactly 'ADR-TST-WIDGET'
        $map.ParentAdr('ADR-TST-SPROCKET-SPIN') | Should -BeNullOrEmpty
    }

    It 'knows the domain prefix of its codes and rejects an unknown code' -Tag 'ADR-REPO-LINK-ONECITATIONSPELLING' {
        $map.IsDomainCode('ADR-TST') | Should -BeTrue
        $map.HasCode('ADR-TST-SPROCKET') | Should -BeFalse
    }

    It 'resolves a unique file name and refuses an ambiguous one' -Tag 'ADR-REPO-LINK-CODELINKS' {
        $map.PathOfSlug('gadget-rules') | Should -BeExactly 'docs/drs/gadget/gadget-rules.md'
        $map.PathOfSlug('widget-notes') | Should -BeNullOrEmpty
        $map.IsAmbiguousSlug('widget-notes') | Should -BeTrue
        $map.IsDocument('docs/drs/gadget/widget-notes.md') | Should -BeTrue
    }
}
