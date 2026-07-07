# The typed read of globs.yml: all sets in registry order, named lookup, throwing on an unknown name.
Describe 'Get-GlobSet' -Tag 'L0', 'logic' {
    BeforeAll {
        # Neutral fixture globset names (widget/gadget), not the real loose-fileset/deployable-unit names, so
        # this logic test owns its inputs and editing the shipped globs.yml can never change its outcome (ADR-TEST:3).
        $script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = [ordered]@{
                    'widget' = @{ description = 'the widget surface'; layer = 'loose-fileset'; include = @('src/**') }
                    'gadget' = @{ description = 'the gadget unit'; layer = 'deployable-unit'; include = @('lib/**') }
                }
            })
    }

    BeforeEach {
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
    }

    It 'returns every globset in registry order when no name is given' {
        $sets = Get-GlobSet
        $sets.Count | Should -Be 2
        $sets[0].Name | Should -Be 'widget'
        $sets[1].Name | Should -Be 'gadget'
    }

    It 'returns the named globsets, in the order asked' {
        $sets = Get-GlobSet -Name gadget, widget
        $sets[0].Name | Should -Be 'gadget'
        $sets[1].Name | Should -Be 'widget'
    }

    It 'returns typed GlobSet objects with working membership' {
        $set = Get-GlobSet -Name gadget
        $set | Should -BeOfType [Catzc.Base.Globs.GlobSet]
        $set.Matches('lib/templates/gadget/main.bicep') | Should -BeTrue
    }

    It 'throws a named error on an unknown globset' {
        { Get-GlobSet -Name nope } | Should -Throw "*no globset named 'nope'*"
    }

    It 'reads the globs config through Get-Config' {
        Get-GlobSet | Out-Null
        Should -Invoke Get-Config -ModuleName Catzc.Base.Globs -ParameterFilter { $Config -eq 'globs' }
    }
}
