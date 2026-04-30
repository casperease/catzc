Describe 'Get-BicepTrackTagNameSet' -Tag 'L0', 'logic' {
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

    It 'returns generic tag names for ResourceGroup-target templates' {
        $names = Get-BicepTrackTagNameSet sample
        $names.commit   | Should -Be 'Deployed_From_Commit'
        $names.build_id | Should -Be 'Deployed_From_BuildId'
        $names.branch   | Should -Be 'Deployed_From_Branch'
    }

    It 'returns template-prefixed names for Subscription-target templates' {
        # Mock Get-BicepTemplate to flip the target without changing the sample's on-disk descriptor
        Mock Get-BicepTemplate {
            [ordered]@{ name = 'sample'; deployment_target = 'Subscription' }
        } -ModuleName Catzc.Azure.Templates

        $names = Get-BicepTrackTagNameSet sample
        $names.commit   | Should -Be 'sample_Deployed_From_Commit'
        $names.build_id | Should -Be 'sample_Deployed_From_BuildId'
        $names.branch   | Should -Be 'sample_Deployed_From_Branch'
    }

    It 'rejects an unknown template' {
        { Get-BicepTrackTagNameSet nonexistent } | Should -Throw
    }
}
