<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/tests/Get-AzureBicepDeploymentTargets.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder-module
    bundle: azure
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
