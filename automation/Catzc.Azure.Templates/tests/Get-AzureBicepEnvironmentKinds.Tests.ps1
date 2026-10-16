<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/tests/Get-AzureBicepEnvironmentKinds.Tests.ps1
    folder: tests
    name: get-azure-bicep-environment-kinds-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
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
