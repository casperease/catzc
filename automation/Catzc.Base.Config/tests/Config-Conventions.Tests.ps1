<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-TEST#35
---
#>

# Poka-yoke backstop for the config registry (see ADR module-config-loading): every shipped config has a registered...
# [comment:1](/docs/references/automation/catzc-base-config/tests/Config-Conventions.Tests.ps1.md#comment1)

Describe 'Config conventions' -Tag 'L0', 'integrity' {
    It 'every shipped config has a registered type and loads through it' {
        # The quality gate (Test-ShippedConfigs, in Catzc.Base.QualityGates: Catzc.Base.Reports depends on...
        # [comment:2](/docs/references/automation/catzc-base-config/tests/Config-Conventions.Tests.ps1.md#comment2)
        $result = Test-ShippedConfigs -PassThru -OutputFolder (Join-Path $TestDrive 'shipped-configs')
        $result.Configs | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
