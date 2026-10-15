<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Timeouts/tests/Get-TestTimeLimits.Tests.ps1
    kind: pester-test
    relatives:
      source: automation/Catzc.Base.Timeouts/Get-TestTimeLimits.ps1
---
#>

Describe 'Get-TestTimeLimits' -Tag 'L0', 'logic' {
    It 'returns the configured tier limits and run budget' {
        Mock Get-Config -ModuleName Catzc.Base.Timeouts {
            [Catzc.Base.Timeouts.TimeoutsConfig]::new([ordered]@{ tests = @{ level_ms = @{ L2 = 45000 }; run_seconds = 240 } })
        }
        $limits = Get-TestTimeLimits
        $limits.LevelMs['L2'] | Should -Be 45000
        $limits.LevelMs['L0'] | Should -Be 400
        $limits.RunSeconds | Should -Be 240
    }

    It 'returns the sensible defaults when the config sets none' {
        Mock Get-Config -ModuleName Catzc.Base.Timeouts { [Catzc.Base.Timeouts.TimeoutsConfig]::new([ordered]@{}) }
        $limits = Get-TestTimeLimits
        $limits.LevelMs['L0'] | Should -Be 400
        $limits.LevelMs['L1'] | Should -Be 2000
        $limits.LevelMs['L2'] | Should -Be 30000
        $limits.LevelMs['L3'] | Should -Be 120000
        $limits.LevelMs['L4'] | Should -Be 600000
        $limits.RunSeconds | Should -Be 180
    }

    It 'returns a copy the caller cannot use to change the config' {
        # One shared instance, so a change through the returned table would show on the next call.
        $script:sharedConfig = [Catzc.Base.Timeouts.TimeoutsConfig]::new([ordered]@{})
        Mock Get-Config -ModuleName Catzc.Base.Timeouts { $script:sharedConfig }
        (Get-TestTimeLimits).LevelMs['L0'] = 1
        (Get-TestTimeLimits).LevelMs['L0'] | Should -Be 400
    }
}
