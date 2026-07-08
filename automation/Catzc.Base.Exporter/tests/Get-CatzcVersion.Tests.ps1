Describe 'Get-CatzcVersion' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-Config {
            [ordered]@{ direct_install_version = '6.6.666'; version = '9.9.9' }
        } -ModuleName Catzc.Base.Exporter -ParameterFilter { $Config -eq 'exporter' }
    }

    It 'returns the direct-install sentinel by default' {
        Get-CatzcVersion | Should -Be '6.6.666'
    }

    It 'returns the published semver under -Published' {
        Get-CatzcVersion -Published | Should -Be '9.9.9'
    }
}
