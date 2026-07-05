Describe 'RootConfigFiles' -Tag 'L0', 'logic' {
    It 'constructs and exposes valid entries in registry order' {
        $c = [Catzc.Base.RootConfig.RootConfigFiles]::new(@{
                files = @(
                    @{ target = 'a.yml'; source = 's/a.yml'; optIn = $true }
                    @{ target = 'importer.ps1'; generator = 'New-Importer'; committed = $true }
                )
            })
        @($c.files).Count | Should -Be 2
        $c.files[0].target | Should -Be 'a.yml'
        $c.files[1].generator | Should -Be 'New-Importer'
    }

    It 'throws when files is missing' {
        { [Catzc.Base.RootConfig.RootConfigFiles]::new(@{}) } | Should -Throw "*'files' must be a list*"
    }

    It 'throws when files is empty' {
        { [Catzc.Base.RootConfig.RootConfigFiles]::new(@{ files = @() }) } | Should -Throw "*'files' must be a list*"
    }

    It 'throws on a duplicate target (case-insensitive)' {
        { [Catzc.Base.RootConfig.RootConfigFiles]::new(@{
                    files = @(
                        @{ target = 'a.yml'; source = 's1' }
                        @{ target = 'A.YML'; source = 's2' }
                    )
                }) } | Should -Throw '*duplicate target*'
    }

    It 'collects every malformed entry into one error' {
        $construct = {
            [Catzc.Base.RootConfig.RootConfigFiles]::new(@{
                    files = @(
                        @{ source = 'no-target' }
                        @{ target = 'both'; source = 's'; generator = 'g' }
                    )
                })
        }
        $construct | Should -Throw '*target is required*'
        $construct | Should -Throw '*exactly one*'
    }
}
