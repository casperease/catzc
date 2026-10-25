<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-config/tests/Config-Conventions.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'Config conventions' -Tag 'L0', 'integrity' {
    It 'every shipped config has a registered type and loads through it' {
        $result = Test-ShippedConfigs -PassThru -OutputFolder (Join-Path $TestDrive 'shipped-configs')
        $result.Facts['Configs'] | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
