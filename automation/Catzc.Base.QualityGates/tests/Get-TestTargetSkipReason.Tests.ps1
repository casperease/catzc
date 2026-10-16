<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Get-TestTargetSkipReason.Tests.ps1
    folder: tests
    name: get-test-target-skip-reason-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-AUTO-TEST#41
---
#>

Describe 'Get-TestTargetSkipReason' -Tag 'L0', 'logic', 'ADR-AUTO-TEST#41' {
    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'test-policy' } {
            [Catzc.Base.QualityGates.TestPolicyConfig]::new([ordered]@{ l4_mutation = @{ 'wid-get' = 'synthetic' } })
        }
    }

    It 'returns nothing when the target is reachable and allows the mode' {
        Get-TestTargetSkipReason -Environment 'wid-get' -Mode Synthetic -Probe { $true } | Should -BeNullOrEmpty
        Get-TestTargetSkipReason -Environment 'gadget' -Mode ReadOnly -Probe { $true } | Should -BeNullOrEmpty
    }

    It 'skips a test that needs synthetic transactions against a read-only target, without probing it' {
        $script:probed = $false
        Get-TestTargetSkipReason -Environment 'gadget' -Mode Synthetic -Probe { $script:probed = $true; $true } | Should -Be 'target_gadget_readonly'
        $script:probed | Should -BeFalse
    }

    It 'skips when the console cannot reach the target: <case>' -ForEach @(
        @{ case = 'the probe says no'; probe = { $false } }
        @{ case = 'the probe throws'; probe = { throw 'no route to the widget' } }
    ) {
        Get-TestTargetSkipReason -Environment 'wid-get' -Mode ReadOnly -Probe $probe | Should -Be 'target_widget_unreachable'
    }

    It 'returns a constrained skip key, the environment kept to letters and digits' {
        $skip = Get-TestTargetSkipReason -Environment 'Gadget-02.Prod' -Mode ReadOnly -Probe { $false }
        $skip | Should -Be 'target_gadget02prod_unreachable'
        $skip | Should -MatchExactly '^[a-z][a-z0-9]*(_[a-z0-9]+)+$'
    }

    It 'throws for an environment with no letter or digit' {
        { Get-TestTargetSkipReason -Environment '--' -Mode ReadOnly -Probe { $true } } | Should -Throw '*no letter or digit*'
    }
}
