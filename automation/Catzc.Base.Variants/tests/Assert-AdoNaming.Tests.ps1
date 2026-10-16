<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/tests/Assert-AdoNaming.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Variants
    relatives:
      source: automation/Catzc.Base.Variants/Assert-AdoNaming.ps1
---
#>

Describe 'Assert-AdoNaming' -Tag 'L0', 'logic' {

    It 'passes when the repo matches the asserted order' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ ado_naming = 'standard' } }
        { Assert-AdoNaming -Standard } | Should -Not -Throw
    }

    It 'throws (naming the actual order) when it does not match' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ ado_naming = 'classic' } }
        { Assert-AdoNaming -Standard } | Should -Throw "*ado_naming 'standard'*is 'classic'*"
    }
}
