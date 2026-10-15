<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1
    kind: pester-test
    relatives:
      source: automation/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
    adrs:
      - ADR-AUTO-TEST#37
---
#>

Describe 'Resolve-TestSuite' -Tag 'L0', 'logic' {
    It 'returns the test suite''s verify modules and level' -Tag 'ADR-AUTO-TEST#37' {
        Mock Get-GlobSet {
            [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'deployable-unit', @('x/**'), @(), @(),
                @('Catzc.Azure.Templates', 'Catzc.Azure'), 2, $null)
        } -ModuleName Catzc.Base.QualityGates

        $scope = InModuleScope Catzc.Base.QualityGates { Resolve-TestSuite -Name unit }
        $scope.Modules | Should -Be @('Catzc.Azure.Templates', 'Catzc.Azure')
        $scope.Level | Should -Be 2
    }

    It 'throws an actionable error when the globset declares no verify scope' -Tag 'ADR-AUTO-TEST#37' {
        Mock Get-GlobSet {
            [Catzc.Base.Globs.GlobSet]::new('bare', 'd', 'loose-fileset', @('x/**'), @(), @(), @(), -1, $null)
        } -ModuleName Catzc.Base.QualityGates

        { InModuleScope Catzc.Base.QualityGates { Resolve-TestSuite -Name bare } } |
            Should -Throw '*declares no verify scope, so it is not a test suite*globs.yml*'
    }
}
