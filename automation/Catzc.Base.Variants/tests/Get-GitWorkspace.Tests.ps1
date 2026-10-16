<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/tests/Get-GitWorkspace.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Variants
    relatives:
      source: automation/Catzc.Base.Variants/Get-GitWorkspace.ps1
---
#>

Describe 'Get-GitWorkspace' -Tag 'L0', 'logic' {

    It 'returns the configured mode' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ git_workspace = 'main-via-pr' } }
        Get-GitWorkspace | Should -Be 'main-via-pr'
    }

    It 'defaults to main-direct when the variant is unset' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{} }
        Get-GitWorkspace | Should -Be 'main-direct'
    }
}
