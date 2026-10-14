# Get-GlossaryEnforcementViolations is private, so it is exercised through the module (InModuleScope, per
# [ADR-PWSH-PESTER#4](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester4)). The glossary is built
# in memory from the real GlossaryEntry/GlossaryConcept/GlossaryOptions
# types and the enforcer map is passed in, in Get-CatsRuleEnforcers' shape, so no test file is read. Fixture terms
# and rule codes are neutral (widget/gadget, tst —
# [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Get-GlossaryEnforcementViolations' -Tag 'L0', 'logic' {
    BeforeAll {
        # One merged glossary entry from the widget's source: realized as a tag unless said otherwise.
        $script:entry = {
            param([string] $term, [string] $definedBy, [string] $kind = 'tag', [string[]] $checks)
            $realization = [ordered]@{ kind = $kind }
            if ($kind -ne 'prose-only') {
                $realization['pattern'] = 'widget'
            }
            $concept = [Catzc.Base.Docs.GlossaryConcept]::new($term, [ordered]@{
                    key         = $term.Replace(' ', '_')
                    domain      = 'automation'
                    defined_by  = $definedBy
                    short       = "The $term."
                    realized_by = $realization
                })
            $options = @{}
            if ($PSBoundParameters.ContainsKey('checks')) {
                $options['checks'] = $checks
            }
            [Catzc.Base.Docs.GlossaryEntry]::new($concept, 'Catzc.Widget', 'automation/Catzc.Widget/configs/glossary.yml',
                [Catzc.Base.Docs.GlossaryOptions]::new($options))
        }
        # ADR-TST-WIDGET#1 is cited by a test, ADR-TST-WIDGET#2 by an analyzer, ADR-TST-WIDGET#3 by nothing.
        $script:enforcer = @{
            'ADR-TST-WIDGET#1' = [pscustomobject]@{ Analyzers = @(); Tests = @('automation/Catzc.Widget/tests/Get-Widget.Tests.ps1') }
            'ADR-TST-WIDGET#2' = [pscustomobject]@{ Analyzers = @('Measure-Widget'); Tests = @() }
            'ADR-TST-WIDGET#3' = [pscustomobject]@{ Analyzers = @(); Tests = @() }
        }
        $script:violations = {
            param([object[]] $entries)
            $found = @(InModuleScope Catzc.Base.Docs -Parameters @{ Entries = $entries; Enforcer = $script:enforcer } {
                    Get-GlossaryEnforcementViolations -Entry $Entries -Enforcer $Enforcer
                })
            Write-Output -NoEnumerate $found   # keep a single violation an array, so .Count and [0] mean what they say
        }
    }

    It 'reports nothing when a test or an analyzer enforces the defining rule' -Tag 'ADR-REPO-VOCAB#6' {
        $entries = @(
            & $script:entry 'widget suite' 'ADR-TST-WIDGET#1'
            & $script:entry 'gadget run' 'ADR-TST-WIDGET#2' 'function'
        )
        & $script:violations $entries | Should -BeNullOrEmpty
    }

    It 'reports a realized concept whose defining rule nothing enforces' -Tag 'ADR-REPO-VOCAB#6' {
        $found = & $script:violations @(
            & $script:entry 'widget suite' 'ADR-TST-WIDGET#3'
            & $script:entry 'gadget run' 'ADR-TST-WIDGET#4' 'folder'
        )
        $found.Count | Should -Be 2
        $found[0] | Should -Be "automation/Catzc.Widget/configs/glossary.yml: concept 'widget suite' is realized as tag 'widget', but no test or analyzer cites its defining rule ADR-TST-WIDGET#3 — tag a test with it or declare the concept prose-only (ADR-REPO-VOCAB#6)"
        $found[1] | Should -BeLike "*: concept 'gadget run' is realized as folder 'widget', but no test or analyzer cites its defining rule ADR-TST-WIDGET#4*"
    }

    It 'exempts a prose-only concept' -Tag 'ADR-REPO-VOCAB#6' {
        & $script:violations @(& $script:entry 'widget suite' 'ADR-TST-WIDGET#4' 'prose-only') | Should -BeNullOrEmpty
    }

    It 'skips a source that opts out of the enforced check' -Tag 'ADR-REPO-VOCAB#2' {
        & $script:violations @(& $script:entry 'widget suite' 'ADR-TST-WIDGET#4' 'tag' @('anchored', 'single', 'avoid')) | Should -BeNullOrEmpty
    }

    It 'reads the repository glossary by default' -Tag 'ADR-REPO-VOCAB#6' {
        # Get-Glossary returns its array as one object (', $sorted'); the default must bind that shape.
        $entries = [Catzc.Base.Docs.GlossaryEntry[]] @(& $script:entry 'widget suite' 'ADR-TST-WIDGET#3')
        Mock Get-Glossary -ModuleName Catzc.Base.Docs -MockWith { , $entries }.GetNewClosure()
        $found = @(InModuleScope Catzc.Base.Docs -Parameters @{ Enforcer = $script:enforcer } { Get-GlossaryEnforcementViolations -Enforcer $Enforcer })
        $found.Count | Should -Be 1
        $found[0] | Should -BeLike "*concept 'widget suite' is realized as tag 'widget'*"
    }
}
