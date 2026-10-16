<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/tests/Get-AzureBicepEnvironmentKinds.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Azure.Templates
    relatives:
      source: automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
---
#>

Describe 'Get-AzureBicepEnvironmentKinds' -Tag 'L0', 'logic' {
    It 'returns standard and subscription' {
        $kinds = Get-AzureBicepEnvironmentKinds
        $kinds | Should -Contain 'standard'
        $kinds | Should -Contain 'subscription'
    }

    It 'returns exactly 2 items' {
        @(Get-AzureBicepEnvironmentKinds).Count | Should -Be 2
    }
}
