<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.Templates/tests/Get-BicepParametersFileName.Tests.ps1
    folder: tests
    name: get-bicep-parameters-file-name-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Get-BicepParametersFileName' -Tag 'L0', 'logic' {
    It 'names a configuration-root artifact by config alone (parameters.CONFIG.json)' {
        & (Get-Module Catzc.Azure.Templates) { Get-BicepParametersFileName -Environment alpha } |
            Should -Be 'parameters.alpha.json'
        & (Get-Module Catzc.Azure.Templates) { Get-BicepParametersFileName -Environment alpha -Slot 001 } |
            Should -Be 'parameters.alpha-001.json'
    }

    It 'names a customer artifact by customer and config (parameters.CUSTOMER.CONFIG.json)' {
        & (Get-Module Catzc.Azure.Templates) { Get-BicepParametersFileName -Environment alpha -Customer acme } |
            Should -Be 'parameters.acme.alpha.json'
        & (Get-Module Catzc.Azure.Templates) { Get-BicepParametersFileName -Environment alpha -Slot 001 -Customer acme } |
            Should -Be 'parameters.acme.alpha-001.json'
    }

    It 'keys distinct customers to distinct artifact names for the same env+slot' {
        & (Get-Module Catzc.Azure.Templates) { Get-BicepParametersFileName -Environment alpha -Customer globex } |
            Should -Be 'parameters.globex.alpha.json'
    }
}
