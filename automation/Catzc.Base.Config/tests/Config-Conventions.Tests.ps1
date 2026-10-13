# Poka-yoke backstop for the config registry (see ADR module-config-loading): every shipped config has a
# registered C# config type and loads through it (Test-ShippedConfigs).

Describe 'Config conventions' -Tag 'L0', 'integrity' {
    It 'every shipped config has a registered type and loads through it' {
        # The quality gate (Test-ShippedConfigs, in Catzc.Base.QualityGates: Catzc.Base.Reports depends on
        # Catzc.Base.Config, so the gate cannot live here) lists every issue over the loaded code root
        # ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
        $result = Test-ShippedConfigs -PassThru -OutputFolder (Join-Path $TestDrive 'shipped-configs')
        $result.Configs | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
