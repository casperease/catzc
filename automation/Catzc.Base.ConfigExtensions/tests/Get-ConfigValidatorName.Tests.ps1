<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ConfigExtensions/tests/Get-ConfigValidatorName.Tests.ps1
    kind: pester-test
    relatives:
      source: automation/Catzc.Base.ConfigExtensions/private/Get-ConfigValidatorName.ps1
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
