<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Config
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-config/tests/Config-Conventions.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#35
---
#>

Describe 'Config conventions' -Tag 'L0', 'integrity' {
    It 'every shipped config has a registered type and loads through it' {
        $result = Test-ShippedConfigs -PassThru -OutputFolder (Join-Path $TestDrive 'shipped-configs')
        $result.Configs | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
