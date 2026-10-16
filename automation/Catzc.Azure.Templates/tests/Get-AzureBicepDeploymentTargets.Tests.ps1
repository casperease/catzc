<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/tests/Get-AzureBicepDeploymentTargets.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Azure.Templates
    relatives:
      source: automation/Catzc.Azure.Templates/Get-AzureBicepDeploymentTargets.ps1
---
#>

Describe 'Get-AzureBicepDeploymentTargets' -Tag 'L0', 'logic' {
    It 'returns Subscription and ResourceGroup' {
        $targets = Get-AzureBicepDeploymentTargets
        $targets | Should -Contain 'Subscription'
        $targets | Should -Contain 'ResourceGroup'
    }

    It 'returns exactly 2 items' {
        @(Get-AzureBicepDeploymentTargets).Count | Should -Be 2
    }
}
