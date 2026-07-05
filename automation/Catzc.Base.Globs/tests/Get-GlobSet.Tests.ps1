# The typed read of globs.yml: all sets in registry order, named lookup, throwing on an unknown name.
Describe 'Get-GlobSet' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = [ordered]@{
                    'automation' = @{ description = 'the automation layer'; include = @('automation/**') }
                    'apex'       = @{ description = 'the apex unit'; include = @('infrastructure/**') }
                }
            })
    }

    BeforeEach {
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
    }

    It 'returns every globset in registry order when no name is given' {
        $sets = Get-GlobSet
        $sets.Count | Should -Be 2
        $sets[0].Name | Should -Be 'automation'
        $sets[1].Name | Should -Be 'apex'
    }

    It 'returns the named globsets, in the order asked' {
        $sets = Get-GlobSet -Name apex, automation
        $sets[0].Name | Should -Be 'apex'
        $sets[1].Name | Should -Be 'automation'
    }

    It 'returns typed GlobSet objects with working membership' {
        $set = Get-GlobSet -Name apex
        $set | Should -BeOfType [Catzc.Base.Globs.GlobSet]
        $set.Matches('infrastructure/templates/apex/main.bicep') | Should -BeTrue
        $set.TriggerPath | Should -Be '.triggers/apex.sha256'
    }

    It 'throws a named error on an unknown globset' {
        { Get-GlobSet -Name nope } | Should -Throw "*no globset named 'nope'*"
    }

    It 'reads the globs config through Get-Config' {
        Get-GlobSet | Out-Null
        Should -Invoke Get-Config -ModuleName Catzc.Base.Globs -ParameterFilter { $Config -eq 'globs' }
    }
}
