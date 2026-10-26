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
            [Catzc.Base.Docs.GlossaryEntry]::new($concept, 'Catzc.Widget', 'widgets/Catzc.Widget/configs/glossary.yml',
                [Catzc.Base.Docs.GlossaryOptions]::new($options))
        }
        # ADR-TST-WIDGET-TESTED is cited by a test, -ANALYZED by an analyzer, -BARE by nothing.
        $script:enforcer = @{
            'ADR-TST-WIDGET-TESTED'   = [pscustomobject]@{ Analyzers = @(); Tests = @('widgets/Catzc.Widget/tests/Get-Widget.Tests.ps1') }
            'ADR-TST-WIDGET-ANALYZED' = [pscustomobject]@{ Analyzers = @('Measure-Widget'); Tests = @() }
            'ADR-TST-WIDGET-BARE'     = [pscustomobject]@{ Analyzers = @(); Tests = @() }
        }
        $script:violations = {
            param([object[]] $entries)
            $found = @(InModuleScope Catzc.Base.Docs -Parameters @{ Entries = $entries; Enforcer = $script:enforcer } {
                    Get-GlossaryEnforcementViolations -Entry $Entries -Enforcer $Enforcer
                })
            Write-Output -NoEnumerate $found   # keep a single violation an array, so .Count and [0] mean what they say
        }
    }

    It 'reports nothing when a test or an analyzer enforces the defining rule' -Tag 'ADR-REPO-VOCAB-REALIZEDBY' {
        $entries = @(
            & $script:entry 'widget suite' 'ADR-TST-WIDGET-TESTED'
            & $script:entry 'gadget run' 'ADR-TST-WIDGET-ANALYZED' 'function'
        )
        & $script:violations $entries | Should -BeNullOrEmpty
    }

    It 'reports a realized concept whose defining rule nothing enforces' -Tag 'ADR-REPO-VOCAB-REALIZEDBY' {
        $found = & $script:violations @(
            & $script:entry 'widget suite' 'ADR-TST-WIDGET-BARE'
            & $script:entry 'gadget run' 'ADR-TST-WIDGET-FOLDED' 'folder'
        )
        $found.Count | Should -Be 2
        $found[0] |
            Should -Be "widgets/Catzc.Widget/configs/glossary.yml: concept 'widget suite' is realized as tag 'widget', but no test or analyzer cites its defining rule ADR-TST-WIDGET-BARE — tag a test with it or declare the concept prose-only (ADR-REPO-VOCAB-REALIZEDBY)"
        $found[1] |
            Should -BeLike "*: concept 'gadget run' is realized as folder 'widget', but no test or analyzer cites its defining rule ADR-TST-WIDGET-FOLDED*"
    }

    It 'exempts a prose-only concept' -Tag 'ADR-REPO-VOCAB-REALIZEDBY' {
        & $script:violations @(& $script:entry 'widget suite' 'ADR-TST-WIDGET-FOLDED' 'prose-only') |
            Should -BeNullOrEmpty
    }

    It 'skips a source that opts out of the enforced check' -Tag 'ADR-REPO-VOCAB-GLOSSARYSOURCE' {
        & $script:violations @(& $script:entry 'widget suite' 'ADR-TST-WIDGET-FOLDED' 'tag' @('anchored', 'single',
                'avoid')) | Should -BeNullOrEmpty
    }

    It 'reads the repository glossary by default' -Tag 'ADR-REPO-VOCAB-REALIZEDBY' {
        # Get-Glossary returns its array as one object (', $sorted'); the default must bind that shape.
        $entries = [Catzc.Base.Docs.GlossaryEntry[]] @(& $script:entry 'widget suite' 'ADR-TST-WIDGET-BARE')
        Mock Get-Glossary -ModuleName Catzc.Base.Docs -MockWith { , $entries }.GetNewClosure()
        $found = @(InModuleScope Catzc.Base.Docs -Parameters @{ Enforcer = $script:enforcer } { Get-GlossaryEnforcementViolations -Enforcer $Enforcer })
        $found.Count | Should -Be 1
        $found[0] | Should -BeLike "*concept 'widget suite' is realized as tag 'widget'*"
    }
}
