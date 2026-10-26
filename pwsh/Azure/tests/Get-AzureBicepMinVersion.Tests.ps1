Describe 'Get-AzureBicepMinVersion' -Tag 'L0', 'logic' {
    # A read-only resolver: the config mock and cache reset run once, not per test.
    BeforeAll {
        # Isolate from the shipped azure.yml: resolve identity from the test config fixture.
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) "tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    It 'returns the configured bicep_min_version from azure.yml as a [version]' {
        $result = Get-AzureBicepMinVersion
        $result | Should -BeOfType ([version])
        $result | Should -Be ([version]'0.30.0')
    }
}
