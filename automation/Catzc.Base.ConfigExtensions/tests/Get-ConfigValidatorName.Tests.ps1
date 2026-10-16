<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.ConfigExtensions/tests/Get-ConfigValidatorName.Tests.ps1
    folder: tests
    name: get-config-validator-name-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.ConfigExtensions
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

# The validator naming convention, on literal names.
Describe 'Get-ConfigValidatorName' -Tag 'L0', 'logic' {
    It 'title-cases each kebab segment' {
        InModuleScope Catzc.Base.ConfigExtensions {
            Get-ConfigValidatorName -Name widget | Should -Be 'Assert-WidgetConfig'
            Get-ConfigValidatorName -Name widget-parts | Should -Be 'Assert-WidgetPartsConfig'
        }
    }
}
