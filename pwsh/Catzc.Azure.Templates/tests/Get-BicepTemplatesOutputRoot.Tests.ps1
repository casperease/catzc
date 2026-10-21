<#
---
catzc:
  immutable:
    with_body_sha: "68d4f6703b02"
  edges:
    code: pwsh/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1
---
#>

Describe 'Get-BicepTemplatesOutputRoot' -Tag 'L0', 'logic' {
    It 'is the repository out folder' {
        Get-BicepTemplatesOutputRoot | Should -Be (Join-Path (Get-RepositoryRoot) 'out')
    }
}
