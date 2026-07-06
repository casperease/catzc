Describe 'GitIgnoreConfig' -Tag 'L0', 'logic' {
    It 'constructs and exposes zones in registry order' {
        $c = [Catzc.Base.Git.GitIgnoreConfig]::new(@{
                zones = @(
                    @{ id = 'a'; title = 'A'; why = 'w'; patterns = @('x') }
                    @{ id = 'b'; title = 'B'; why = 'w'; inject = 'p' }
                )
            })
        @($c.zones.id) | Should -Be @('a', 'b')
    }

    It 'throws when zones is missing or empty' {
        { [Catzc.Base.Git.GitIgnoreConfig]::new(@{}) } | Should -Throw "*'zones' must be a list*"
        { [Catzc.Base.Git.GitIgnoreConfig]::new(@{ zones = @() }) } | Should -Throw "*'zones' must be a list*"
    }

    It 'throws on a duplicate zone id (case-insensitive)' {
        { [Catzc.Base.Git.GitIgnoreConfig]::new(@{
                    zones = @(
                        @{ id = 'a'; title = 'A'; why = 'w'; patterns = @('x') }
                        @{ id = 'A'; title = 'B'; why = 'w'; patterns = @('y') }
                    )
                }) } | Should -Throw '*duplicate zone id*'
    }

    It 'collects every malformed zone into one error' {
        $construct = {
            [Catzc.Base.Git.GitIgnoreConfig]::new(@{
                    zones = @(
                        @{ title = 'no id'; why = 'w'; patterns = @('x') }
                        @{ id = 'both'; title = 't'; why = 'w'; patterns = @('a'); inject = 'p' }
                    )
                })
        }
        $construct | Should -Throw '*id is required*'
        $construct | Should -Throw '*exactly one*'
    }
}
