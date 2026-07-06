Describe 'Resolve-MarkerVerify' -Tag 'L0', 'logic' {
    It 'returns the marker''s verify modules and level' {
        Mock Get-GlobSet {
            [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'deployable-unit', @('x/**'), @(), @(),
                @('Catzc.Azure.Templates', 'Catzc.Azure'), 2, $null)
        } -ModuleName Catzc.Base.QualityGates

        $scope = InModuleScope Catzc.Base.QualityGates { Resolve-MarkerVerify -Name unit }
        $scope.Modules | Should -Be @('Catzc.Azure.Templates', 'Catzc.Azure')
        $scope.Level | Should -Be 2
    }

    It 'throws an actionable error when the marker declares no verify scope' {
        Mock Get-GlobSet {
            [Catzc.Base.Globs.GlobSet]::new('bare', 'd', 'loose-fileset', @('x/**'), @(), @(), @(), -1, $null)
        } -ModuleName Catzc.Base.QualityGates

        { InModuleScope Catzc.Base.QualityGates { Resolve-MarkerVerify -Name bare } } |
            Should -Throw '*declares no verify scope*globs.yml*'
    }
}
