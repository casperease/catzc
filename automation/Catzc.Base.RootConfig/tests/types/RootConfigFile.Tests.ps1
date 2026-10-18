Describe 'RootConfigFile' -Tag 'L0', 'logic' {
    It 'constructs a source copy-in and exposes its fields with defaults' {
        $f = [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = '.editorconfig'; source = 'a/b/.editorconfig' })
        $f.target | Should -Be '.editorconfig'
        $f.source | Should -Be 'a/b/.editorconfig'
        $f.generator | Should -BeNullOrEmpty
        $f.carrier | Should -BeNullOrEmpty
        $f.optIn | Should -BeFalse
        $f.committed | Should -BeFalse
        $f.copyAsLink | Should -BeFalse
    }

    It 'constructs a generator entry' {
        $f = [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = 'importer.ps1'; generator = 'New-Importer'; committed = $true; optIn = $true })
        $f.generator | Should -Be 'New-Importer'
        $f.source | Should -BeNullOrEmpty
        $f.committed | Should -BeTrue
        $f.optIn | Should -BeTrue
    }

    It 'presents as a read-only dictionary (DictionaryRecord)' {
        $f = [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = 't'; source = 's'; carrier = 'dotfile' })
        $f.Contains('target') | Should -BeTrue
        $f['carrier'] | Should -Be 'dotfile'
    }

    It 'throws when target is missing' {
        { [Catzc.Base.RootConfig.RootConfigFile]::new(@{ source = 's' }) } | Should -Throw '*target is required*'
    }

    It 'throws when both source and generator are declared' {
        { [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = 't'; source = 's'; generator = 'g' }) } |
            Should -Throw '*exactly one*'
    }

    It 'throws when neither source nor generator is declared' {
        { [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = 't' }) } | Should -Throw '*exactly one*'
    }

    It 'lists the sources of a generator entry, and none for any other entry' {
        $generated = [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = 't'; generator = 'g'; sources = @('a/widget.yml', 'a/gadget.yml') })
        $generated.sources | Should -Be @('a/widget.yml', 'a/gadget.yml')
        [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = 't'; generator = 'g' }).sources.Count | Should -Be 0
        [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = 't'; source = 's' }).sources.Count | Should -Be 0
    }

    It 'throws when a source copy-in lists sources' {
        { [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = 't'; source = 's'; sources = @('a/widget.yml') }) } |
            Should -Throw '*lists ''sources'' but no ''generator''*'
    }

    It 'carries the carrier of a source copy-in and of a generator entry' {
        [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = 't'; source = 's'; carrier = 'dotfile' }).carrier | Should -Be 'dotfile'
        [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = 't'; generator = 'g'; carrier = 'go-workspace' }).carrier | Should -Be 'go-workspace'
    }

    It 'constructs a generator entry with a wildcard target' {
        $f = [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = 'widgets/*/gadget.txt'; generator = 'New-Widget' })
        $f.target | Should -Be 'widgets/*/gadget.txt'
    }

    It 'throws when a source entry has a wildcard target' {
        foreach ($target in 'widgets/*/gadget.txt', 'widget?.txt', 'widget[0].txt') {
            { [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = $target; source = 's' }) } |
                Should -Throw '*wildcard target but no ''generator''*'
        }
    }

    It 'constructs a copyAsLink source entry' {
        $f = [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = '.editorconfig'; source = 'a/b/.editorconfig'; copyAsLink = $true; optIn = $true })
        $f.copyAsLink | Should -BeTrue
        $f.committed | Should -BeFalse
    }

    It 'throws when a generator entry declares copyAsLink' {
        { [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = 't'; generator = 'g'; copyAsLink = $true }) } |
            Should -Throw '*no ''source''*'
    }

    It 'throws when a copyAsLink entry declares committed true' {
        { [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = 't'; source = 's'; copyAsLink = $true; committed = $true }) } |
            Should -Throw '*committed true*'
    }

    It 'throws when a copyAsLink entry declares a carrier' {
        { [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = 't'; source = 's'; copyAsLink = $true; carrier = 'dotfile' }) } |
            Should -Throw '*must not declare ''carrier''*'
    }
}
