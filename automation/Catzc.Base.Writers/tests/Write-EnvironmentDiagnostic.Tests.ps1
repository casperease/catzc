<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Writers/tests/Write-EnvironmentDiagnostic.Tests.ps1
    kind: pester-test
    relatives:
      source: automation/Catzc.Base.Writers/Write-EnvironmentDiagnostic.ps1
---
#>

Describe 'Write-EnvironmentDiagnostic' -Tag 'L0', 'logic' {
    It 'produces output' {
        $result = Write-EnvironmentDiagnostic | Out-String
        $result | Should -Not -BeNullOrEmpty
    }

    It 'includes known environment variables' {
        $result = Write-EnvironmentDiagnostic | Out-String
        $result | Should -Match 'PATH'
    }
}
