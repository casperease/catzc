<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Templates/tests/Get-AzureBicepDeploymentModes.Tests.ps1
    folder: tests
    name: get-azure-bicep-deployment-modes-tests
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
