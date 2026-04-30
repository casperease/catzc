Describe 'Get-BicepTemplateNames' -Tag 'L0', 'logic' {
    # Read-only resolver tests: boundary mocks + config-cache reset run ONCE, not per test — the mocked
    # config is identical every test and no test mutates it, so the cache stays warm (ADR-TEST:19/ADR-TEST:4).
    BeforeAll {
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    It 'returns the discovered template names as a flat string array' {
        $names = Get-BicepTemplateNames
        $names | Should -Contain 'sample'
        $names | Should -Contain 'sample-indexed'
        foreach ($n in $names) {
            $n | Should -BeOfType [string]
        }
    }

    It 'matches the names from Get-BicepTemplates' {
        $expected = @((Get-BicepTemplates) | ForEach-Object { $_.name })
        @(Get-BicepTemplateNames | Sort-Object) | Should -Be @($expected | Sort-Object)
    }
}
