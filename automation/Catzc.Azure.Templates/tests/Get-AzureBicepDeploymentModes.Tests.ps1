<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/tests/Get-AzureBicepDeploymentModes.Tests.ps1
    kind: pester-test
    relatives:
      source: automation/Catzc.Azure.Templates/Get-AzureBicepDeploymentModes.ps1
---
#>

Describe 'Get-AzureBicepDeploymentModes' -Tag 'L0', 'logic' {
    It 'returns Incremental, Complete, DoNotRun' {
        $modes = Get-AzureBicepDeploymentModes
        $modes | Should -Contain 'Incremental'
        $modes | Should -Contain 'Complete'
        $modes | Should -Contain 'DoNotRun'
    }

    It 'returns exactly 3 items' {
        @(Get-AzureBicepDeploymentModes).Count | Should -Be 3
    }
}
