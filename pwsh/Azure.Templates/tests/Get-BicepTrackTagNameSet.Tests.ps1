Describe 'Get-BicepTrackTagNameSet' -Tag 'L0', 'logic' {
    # Read-only resolver: mocks and the cache reset run once, since the mocked config is identical every test and none mutates it.
    BeforeAll {
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) 'tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-CatzcModuleRoot -Module Catzc.Azure.Templates) "tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    It 'returns generic tag names for ResourceGroup-target templates' {
        $names = Get-BicepTrackTagNameSet sample
        $names.commit   | Should -Be 'deployed-from-commit'
        $names.build_id | Should -Be 'deployed-from-buildid'
        $names.branch   | Should -Be 'deployed-from-branch'
    }

    It 'returns template-prefixed names for Subscription-target templates' {
        # Mock Get-BicepTemplate to flip the target without changing the sample's on-disk descriptor
        Mock Get-BicepTemplate {
            [ordered]@{ name = 'sample'; deployment_target = 'Subscription' }
        } -ModuleName Catzc.Azure.Templates

        $names = Get-BicepTrackTagNameSet sample
        $names.commit   | Should -Be 'sample-deployed-from-commit'
        $names.build_id | Should -Be 'sample-deployed-from-buildid'
        $names.branch   | Should -Be 'sample-deployed-from-branch'
    }

    It 'rejects an unknown template' {
        { Get-BicepTrackTagNameSet nonexistent } | Should -Throw
    }
}
