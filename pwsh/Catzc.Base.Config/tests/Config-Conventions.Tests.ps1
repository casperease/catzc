<#
---
catzc:
  immutable:
    with_body_sha: c71abf839afa
  edges:
    docs: "[Config-Conventions.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-config/tests/Config-Conventions.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
---
#>

Describe 'Config conventions' -Tag 'L0', 'integrity' {
    It 'every shipped config has a registered type and loads through it' {
        $result = Test-ShippedConfigs -PassThru -OutputFolder (Join-Path $TestDrive 'shipped-configs')
        $result.Facts['Configs'] | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
