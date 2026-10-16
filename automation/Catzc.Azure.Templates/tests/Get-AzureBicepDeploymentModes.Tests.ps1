<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/tests/Get-AzureBicepDeploymentModes.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder-module
    bundle: azure
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
