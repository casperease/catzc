Describe 'BicepConfig' -Tag 'L0' {

    Context 'integrity (shipped bicep.yml)' -Tag 'integrity' {
        It 'loads the shipped bicep.yml as a BicepConfig' {
            Get-Config -Config bicep | Should -BeOfType [Catzc.Base.Languages.BicepConfig]
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'takes the public registry when package_source is absent' {
            foreach ($raw in [ordered]@{}, $null) {
                [Catzc.Base.Languages.BicepConfig]::new($raw).package_source | Should -Be ([Catzc.Base.Languages.PackageSource]::BicepRegistry)
            }
        }

        It 'reads a declared package_source' {
            $config = [Catzc.Base.Languages.BicepConfig]::new([ordered]@{ package_source = [ordered]@{ url = 'registry.widget.test/bicep' } })
            $config.package_source.url | Should -Be 'registry.widget.test/bicep'
            $config.package_source.name | Should -Be 'mcr'
        }

        It 'takes the core analyzer, enabled and not verbose, when analyzers is absent' {
            $analyzers = [Catzc.Base.Languages.BicepConfig]::new([ordered]@{}).analyzers
            @($analyzers.Keys) | Should -Be @('core')
            $analyzers['core']['enabled'] | Should -BeTrue
            $analyzers['core']['verbose'] | Should -BeFalse
        }

        It 'reads declared analyzers in their order' {
            $raw = [ordered]@{ analyzers = [ordered]@{ widget = [ordered]@{ enabled = $false }; gadget = [ordered]@{ verbose = $true } } }
            $analyzers = [Catzc.Base.Languages.BicepConfig]::new($raw).analyzers
            @($analyzers.Keys) | Should -Be @('widget', 'gadget')
            $analyzers['widget']['enabled'] | Should -BeFalse
        }

        It 'rejects analyzers that is not a map of maps, naming the key' {
            { [Catzc.Base.Languages.BicepConfig]::new([ordered]@{ analyzers = 'widget' }) } | Should -Throw '*invalid analyzers*'
            { [Catzc.Base.Languages.BicepConfig]::new([ordered]@{ analyzers = [ordered]@{ widget = 1 } }) } | Should -Throw '*analyzers.widget*'
        }

        It 'rejects an unknown key and a bad package_source url, naming the key' {
            { [Catzc.Base.Languages.BicepConfig]::new([ordered]@{ nope = 1 }) } | Should -Throw '*unknown key ''nope''*'
            { [Catzc.Base.Languages.BicepConfig]::new([ordered]@{ package_source = [ordered]@{ url = 'not a host' } }) } | Should -Throw '*package_source.url*'
        }
    }
}
