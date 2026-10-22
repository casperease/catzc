<#
---
catzc:
  immutable:
    with_body_sha: aabbf2324d2d
  edges:
    code: pwsh/Catzc.Base.QualityGates/private/Resolve-PlanStepCount.ps1
    cites:
      - ADR-REPO-PLANS-THREEPARTS
---
#>

Describe 'Resolve-PlanStepCount' -Tag 'L0', 'logic', 'ADR-REPO-PLANS-THREEPARTS' {
    BeforeAll {
        $script:resolve = {
            param([hashtable] $Arguments)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Arguments = $Arguments } {
                param($Arguments)
                Resolve-PlanStepCount @Arguments
            }
        }
    }

    It 'finds a count written in a word or in digits, and where it stands' {
        $found = & $script:resolve @{ Text = '- widget -> plan-widget.md: Three steps left, the spin' }
        $found.Count | Should -Be 3
        $found.Index | Should -Be 28
        $found.Length | Should -Be 11
        (& $script:resolve @{ Text = 'gadget: 14 steps open' }).Count | Should -Be 14
        (& $script:resolve @{ Text = 'one step left' }).Count | Should -Be 1
    }

    It 'finds nothing in a text that states no count' {
        & $script:resolve @{ Text = 'spin the widget, then step back' } | Should -BeNullOrEmpty
        & $script:resolve @{ Text = '' } | Should -BeNullOrEmpty
    }

    It 'writes a count in words up to twelve, in digits above, and one step in the singular' {
        & $script:resolve @{ Count = 1 } | Should -BeExactly 'one step'
        & $script:resolve @{ Count = 12 } | Should -BeExactly 'twelve steps'
        & $script:resolve @{ Count = 13 } | Should -BeExactly '13 steps'
        & $script:resolve @{ Count = 0 } | Should -BeExactly '0 steps'
    }
}
