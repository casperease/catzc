<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Writers/tests/Write-EnvironmentDiagnostic.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Writers
    moduletype: pwsh-folder-module
    bundle: azure
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
