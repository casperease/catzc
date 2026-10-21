<#
---
catzc:
  immutable:
    with_body_sha: de66140d6ad9
  edges:
    docs: "[Get-TestRuleTags.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/tests/Get-TestRuleTags.Tests.ps1.md)"
    code: pwsh/Catzc.Base.QualityGates/private/Get-TestRuleTags.ps1
    cites:
      - ADR-AUTO-TEST-PROVENANCETAGS
---
#>

Describe 'Get-TestRuleTags' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-PROVENANCETAGS' {
    BeforeAll {
        function New-FakeTest {
            param([string[]] $OwnTags = @(), [string[]] $InnerTags = @(), [string[]] $OuterTags)
            $root = [pscustomobject]@{ IsRoot = $true; Tag = @(); Parent = $null }
            $parent = if ($PSBoundParameters.ContainsKey('OuterTags')) {
                [pscustomobject]@{ IsRoot = $false; Tag = @($OuterTags); Parent = $root }
            }
            else {
                $root
            }
            $inner = [pscustomobject]@{ IsRoot = $false; Tag = @($InnerTags); Parent = $parent }
            [pscustomobject]@{ Tag = @($OwnTags); Block = $inner }
        }

        # @(...) re-arrayifies: InModuleScope (a pipeline boundary) unrolls a single-element array to a scalar.
        $script:rules = { param($Test) @(InModuleScope Catzc.Base.QualityGates -Parameters @{ T = $Test } { param($T) Get-TestRuleTags -Test $T }) }
    }

    It 'unions citations across own tags and every ancestor block' {
        $result = & $script:rules (New-FakeTest -OwnTags @('L0', 'logic', 'ADR-WIDGET-GADGET-SPIN') -InnerTags @('ADR-WIDGET-GADGET-TURN') -OuterTags @('ADR-WIDGET-GADGET-STOP'))
        $result | Should -Be @('ADR-WIDGET-GADGET-SPIN', 'ADR-WIDGET-GADGET-STOP', 'ADR-WIDGET-GADGET-TURN')
    }

    It 'de-duplicates a citation carried at more than one level' {
        $result = & $script:rules (New-FakeTest -OwnTags @('ADR-WIDGET-GADGET-SPIN') -InnerTags @('ADR-WIDGET-GADGET-SPIN'))
        $result | Should -Be @('ADR-WIDGET-GADGET-SPIN')
    }

    It 'ignores the tier, category and serial tags' {
        (& $script:rules (New-FakeTest -InnerTags @('L2', 'integrity', 'serial'))) | Should -HaveCount 0
    }

    It 'ignores a malformed citation (the numbered and colon forms, an ADR code that names no rule, wrong case)' {
        $result = & $script:rules (New-FakeTest -InnerTags @('ADR-WIDGET-GADGET#3', 'ADR-WIDGET-GADGET:3', 'ADR-WIDGET-GADGET', 'adr-widget-gadget-spin'))
        $result | Should -HaveCount 0
    }

    It 'returns empty when the test carries no citation' {
        (& $script:rules (New-FakeTest -OwnTags @('L0', 'logic'))) | Should -HaveCount 0
    }
}
