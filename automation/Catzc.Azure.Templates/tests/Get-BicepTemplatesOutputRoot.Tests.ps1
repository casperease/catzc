<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/tests/Get-BicepTemplatesOutputRoot.Tests.ps1
    kind: pester-test
    relatives:
      source: automation/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1
---
#>

Describe 'Get-BicepTemplatesOutputRoot' -Tag 'L0', 'logic' {
    It 'is the repository out folder' {
        Get-BicepTemplatesOutputRoot | Should -Be (Join-Path (Get-RepositoryRoot) 'out')
    }
}
