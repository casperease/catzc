<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Variants/tests/Get-AdoNaming.Tests.ps1
    folder: tests
    name: get-ado-naming-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
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
