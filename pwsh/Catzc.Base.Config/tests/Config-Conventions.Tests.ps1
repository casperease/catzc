<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1
    folder: tests
    name: config-conventions-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Config
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Config-Conventions.Tests.ps1.md](docs/references/pwsh/catzc-base-config/tests/Config-Conventions.Tests.ps1.md)"
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
