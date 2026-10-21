<#
---
catzc:
  immutable:
    with_body_sha: "275111c97cb3"
  edges:
    code: pwsh/Catzc.Base.ConfigExtensions/private/Get-ConfigValidatorName.ps1
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
