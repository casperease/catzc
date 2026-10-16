<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Writers/tests/Write-EnvironmentDiagnostic.Tests.ps1
    folder: tests
    name: write-environment-diagnostic-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Writers
    moduletype: pwsh-folder
    catzc_bundle: azure
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
