<#
---
catzc:
  immutable:
    with_body_sha: "3fa033b17043"
  edges:
    code: pwsh/Catzc.Base.Variants/Get-AdoNaming.ps1
---
#>

Describe 'Get-AdoNaming' -Tag 'L0', 'logic' {

    It 'returns the configured ado_naming value' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ ado_naming = 'classic' } }
        Get-AdoNaming | Should -Be 'classic'
    }

    It 'defaults to standard when ado_naming is unset' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [Catzc.Base.Variants.VariantsConfig]::new([ordered]@{ tracks = [ordered]@{ widgets = [ordered]@{ places = @('widgetry'); type = 'modules' } } }) }
        Get-AdoNaming | Should -Be 'standard'
    }
}
