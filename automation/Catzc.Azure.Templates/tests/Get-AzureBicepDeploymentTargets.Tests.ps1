<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Templates/tests/Get-AzureBicepDeploymentTargets.Tests.ps1
    folder: tests
    name: get-azure-bicep-deployment-targets-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
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
