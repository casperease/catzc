# Get-GlossaryAnchorViolations is private, so it is exercised through the module (InModuleScope, per
# [ADR-PWSH-PESTER#4](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester4)). A fixture ADR index and
# ADR live in $TestDrive, and the glossary is built in memory from the
# real GlossaryEntry/GlossaryConcept/GlossaryOptions types, so each test breaks exactly one anchoring fact. Fixture
# terms and rule codes are neutral (widget/gadget, tst —
# [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Get-GlossaryAnchorViolations' -Tag 'L0', 'logic' {
    BeforeAll {
        $adrRoot = Join-Path $TestDrive 'adr'
        [System.IO.Directory]::CreateDirectory((Join-Path $adrRoot 'repository')) | Out-Null
        $script:indexPath = Join-Path $adrRoot 'index.md'
        [System.IO.File]::WriteAllText($script:indexPath, (@(
                    '# ADR index'
                    ''
                    '| Code | ADR |'
                    '| ---- | --- |'
                    '| `ADR-TST-WIDGET` | [widget-thing](repository/widget-thing.md) |'
                ) -join "`n"))
        [System.IO.File]::WriteAllText((Join-Path $adrRoot 'repository/widget-thing.md'), (@(
                    '# ADR: Widget thing'
                    ''
                    '### Rule ADR-TST-WIDGET:1'
                    ''
                    'A **Widget'
                    'Suite** is every widget file at rest.'
                    ''
                    '### Rule ADR-TST-WIDGET:2'
                    ''
                    'Gadgets run widgets, and the `**gadget run**` mention is not bold text.'
                    ''
                    '- [**gadget run**](#context)'
                    ''
                    '## Context'
                    ''
                    'A **gadget run** executes widgets.'
                ) -join "`n"))

        # One merged glossary entry: a prose-only concept from the widget's source, with the source's optional checks.
        $script:entry = {
            param([string] $term, [string] $definedBy, [string[]] $checks)
            $concept = [Catzc.Base.Docs.GlossaryConcept]::new($term, [ordered]@{
                    key         = $term.Replace(' ', '_')
                    domain      = 'repository'
                    defined_by  = $definedBy
                    short       = "The $term."
                    realized_by = [ordered]@{ kind = 'prose-only' }
                })
            $options = @{}
            if ($PSBoundParameters.ContainsKey('checks')) {
                $options['checks'] = $checks
            }
            [Catzc.Base.Docs.GlossaryEntry]::new($concept, 'Catzc.Widget', 'automation/Catzc.Widget/configs/glossary.yml',
                [Catzc.Base.Docs.GlossaryOptions]::new($options))
        }
        $script:violations = {
            param([object[]] $entries)
            $found = @(InModuleScope Catzc.Base.Docs -Parameters @{ Entries = $entries; IndexPath = $script:indexPath } {
                    Get-GlossaryAnchorViolations -Entry $Entries -IndexPath $IndexPath
                })
            Write-Output -NoEnumerate $found   # keep a single violation an array, so .Count and [0] mean what they say
        }
    }

    It 'reports nothing when the defining rule bolds the term, across a wrapped line and in any case' -Tag 'ADR-REPO-VOCAB#1' {
        & $script:violations @(& $script:entry 'widget suite' 'ADR-TST-WIDGET#1') | Should -BeNullOrEmpty
    }

    It 'reports a defined_by that names no rule' -Tag 'ADR-REPO-VOCAB#1' {
        $found = & $script:violations @(& $script:entry 'widget suite' 'ADR-TST-WIDGET#9')
        $found.Count | Should -Be 1
        $found[0] | Should -Be "automation/Catzc.Widget/configs/glossary.yml: concept 'widget suite': defined_by 'ADR-TST-WIDGET#9' names no rule in an indexed ADR (ADR-REPO-VOCAB#1)"
    }

    It 'reports a defining rule whose summary does not bold the term' -Tag 'ADR-REPO-VOCAB#1' {
        $found = & $script:violations @(& $script:entry 'widget suite' 'ADR-TST-WIDGET#2')
        $found.Count | Should -Be 1
        $found[0] | Should -BeLike "automation/Catzc.Widget/configs/glossary.yml: concept 'widget suite': the normative summary of ADR-TST-WIDGET#2 does not bold '**widget suite**'*"
    }

    It 'does not count bold text in the ADR body, a linked bullet, or a code span' -Tag 'ADR-REPO-VOCAB#1' {
        $found = & $script:violations @(& $script:entry 'gadget run' 'ADR-TST-WIDGET#2')
        $found.Count | Should -Be 1
        $found[0] | Should -BeLike "*concept 'gadget run': the normative summary of ADR-TST-WIDGET#2 does not bold '**gadget run**'*"
    }

    It 'skips a source that opts out of the anchored check' -Tag 'ADR-REPO-VOCAB#2' {
        $entries = @(
            & $script:entry 'gadget run' 'ADR-TST-WIDGET#2' @('single', 'avoid', 'enforced')
            & $script:entry 'widget suite' 'ADR-TST-WIDGET#9' @()
        )
        & $script:violations $entries | Should -BeNullOrEmpty
    }

    It 'reports nothing for an empty glossary' {
        & $script:violations @() | Should -BeNullOrEmpty
    }

    It 'reads the repository glossary by default' -Tag 'ADR-REPO-VOCAB#1' {
        # Get-Glossary returns its array as one object (', $sorted'); the default must bind that shape.
        $entries = [Catzc.Base.Docs.GlossaryEntry[]] @(& $script:entry 'widget suite' 'ADR-TST-WIDGET#9')
        Mock Get-Glossary -ModuleName Catzc.Base.Docs -MockWith { , $entries }.GetNewClosure()
        $found = @(InModuleScope Catzc.Base.Docs -Parameters @{ IndexPath = $script:indexPath } { Get-GlossaryAnchorViolations -IndexPath $IndexPath })
        $found.Count | Should -Be 1
        $found[0] | Should -BeLike "*defined_by 'ADR-TST-WIDGET#9' names no rule*"
    }
}
