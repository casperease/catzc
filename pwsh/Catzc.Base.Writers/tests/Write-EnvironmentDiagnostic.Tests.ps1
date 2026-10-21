<#
---
catzc:
  immutable:
    with_body_sha: "0827fe7f295b"
  edges:
    code: pwsh/Catzc.Base.Writers/Write-EnvironmentDiagnostic.ps1
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
