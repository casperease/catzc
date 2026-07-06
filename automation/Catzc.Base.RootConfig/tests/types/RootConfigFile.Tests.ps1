Describe 'RootConfigFile' -Tag 'L0', 'logic' {
    It 'constructs a source copy-in and exposes its fields with defaults' {
        $f = [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = '.editorconfig'; source = 'a/b/.editorconfig' })
        $f.target | Should -Be '.editorconfig'
        $f.source | Should -Be 'a/b/.editorconfig'
        $f.generator | Should -BeNullOrEmpty
        $f.comment | Should -Be 'none'
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
        $f = [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = 't'; source = 's'; comment = 'hash' })
        $f.Contains('target') | Should -BeTrue
        $f['comment'] | Should -Be 'hash'
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

    It 'throws on an unknown comment style' {
        { [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = 't'; source = 's'; comment = 'block' }) } |
            Should -Throw '*unknown comment style*'
    }

    It 'throws when a generator entry declares a comment style' {
        { [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = 't'; generator = 'g'; comment = 'hash' }) } |
            Should -Throw '*must not declare*'
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

    It 'throws when a copyAsLink entry declares a comment style, even an explicit none' {
        { [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = 't'; source = 's'; copyAsLink = $true; comment = 'hash' }) } |
            Should -Throw '*must not declare ''comment''*'
        { [Catzc.Base.RootConfig.RootConfigFile]::new(@{ target = 't'; source = 's'; copyAsLink = $true; comment = 'none' }) } |
            Should -Throw '*must not declare ''comment''*'
    }
}
