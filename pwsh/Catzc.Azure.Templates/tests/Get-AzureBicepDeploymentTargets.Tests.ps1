<#
---
catzc:
  immutable:
    with_body_sha: d6f8a4f43b5a
  edges:
    code: pwsh/Catzc.Azure.Templates/Get-AzureBicepDeploymentTargets.ps1
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
