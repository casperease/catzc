Describe 'GitIgnoreZone' -Tag 'L0', 'logic' {
    It 'constructs a static zone with mixed bare and noted patterns' {
        $z = [Catzc.Base.Git.GitIgnoreZone]::new(@{
                id = 'output'; title = 'Output'; why = 'Generated artifacts.'
                patterns = @('out/*', @{ pattern = '!out/.gitkeep'; note = 'anchor' })
            })
        @($z.patterns).Count | Should -Be 2
        $z.patterns[1].note | Should -Be 'anchor'
        $z.inject | Should -BeNullOrEmpty
    }

    It 'constructs an inject zone' {
        $z = [Catzc.Base.Git.GitIgnoreZone]::new(@{ id = 'rc'; title = 'Managed'; why = 'Injected.'; inject = 'provider-x' })
        $z.inject | Should -Be 'provider-x'
        @($z.patterns).Count | Should -Be 0
    }

    It 'throws when both or neither of patterns/inject are declared' {
        { [Catzc.Base.Git.GitIgnoreZone]::new(@{ id = 'z'; title = 't'; why = 'w'; patterns = @('a'); inject = 'p' }) } |
            Should -Throw '*exactly one*'
        { [Catzc.Base.Git.GitIgnoreZone]::new(@{ id = 'z'; title = 't'; why = 'w' }) } | Should -Throw '*exactly one*'
    }

    It 'throws when a required field is missing' {
        { [Catzc.Base.Git.GitIgnoreZone]::new(@{ title = 't'; why = 'w'; patterns = @('a') }) } | Should -Throw '*id is required*'
        { [Catzc.Base.Git.GitIgnoreZone]::new(@{ id = 'z'; title = 't'; patterns = @('a') }) } | Should -Throw '*why is required*'
    }
}
