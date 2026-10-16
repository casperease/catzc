<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/tests/Assert-HaveCustomer.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Variants
    relatives:
      source: automation/Catzc.Base.Variants/Assert-HaveCustomer.ps1
---
#>

Describe 'Assert-HaveCustomer' -Tag 'L0', 'logic' {

    It 'passes when the single customer is enabled' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = 'all' } }
        { Assert-HaveCustomer acme } | Should -Not -Throw
    }

    It 'throws when the single customer is not enabled' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ have_customers = @('acme') } }
        { Assert-HaveCustomer globex } | Should -Throw '*globex*'
    }
}
