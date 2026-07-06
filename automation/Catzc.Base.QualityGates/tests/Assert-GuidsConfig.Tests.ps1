Describe 'Assert-GuidsConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:assert = {
            param($Config)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ C = $Config } { param($C) Assert-GuidsConfig -Config $C }
        }
    }

    It 'accepts a well-formed registry' {
        $config = [ordered]@{ guids = [ordered]@{
                ado_oauth_resource = [ordered]@{ guid = '499b84ac-1321-427f-aa17-267ca6975798'; description = 'ADO OAuth resource id' }
                fixture_alpha      = [ordered]@{ guid = 'a1a7e577-ea70-0000-0000-000000000000'; description = 'alpha fixture tenant'; sentence = 'alpha test tenant' }
            }
        }
        { & $script:assert $config } | Should -Not -Throw
    }

    It 'accepts an empty registry' {
        { & $script:assert ([ordered]@{ guids = $null }) } | Should -Not -Throw
    }

    It 'throws when the guids key is missing' {
        { & $script:assert ([ordered]@{ }) } | Should -Throw '*Missing required top-level key*'
    }

    It 'throws on a non-snake_case entry name' {
        $config = [ordered]@{ guids = [ordered]@{
                'Bad-Name' = [ordered]@{ guid = 'a1a7e577-ea70-0000-0000-000000000000'; description = 'x' }
            }
        }
        { & $script:assert $config } | Should -Throw '*is invalid (must be snake_case*'
    }

    It 'throws on a missing guid' {
        $config = [ordered]@{ guids = [ordered]@{ entry = [ordered]@{ description = 'x' } } }
        { & $script:assert $config } | Should -Throw "*entry 'entry' is missing 'guid'*"
    }

    It 'throws on a non-canonical (uppercase) guid' {
        $config = [ordered]@{ guids = [ordered]@{
                entry = [ordered]@{ guid = 'A1A7E577-EA70-0000-0000-000000000000'; description = 'x' }
            }
        }
        { & $script:assert $config } | Should -Throw '*canonical lowercase hyphenated form*'
    }

    It 'throws on a duplicate guid value' {
        $config = [ordered]@{ guids = [ordered]@{
                one = [ordered]@{ guid = 'a1a7e577-ea70-0000-0000-000000000000'; description = 'x' }
                two = [ordered]@{ guid = 'a1a7e577-ea70-0000-0000-000000000000'; description = 'y' }
            }
        }
        { & $script:assert $config } | Should -Throw '*Duplicate guid value*'
    }

    It 'throws on a missing description' {
        $config = [ordered]@{ guids = [ordered]@{
                entry = [ordered]@{ guid = 'a1a7e577-ea70-0000-0000-000000000000' }
            }
        }
        { & $script:assert $config } | Should -Throw "*missing a non-empty 'description'*"
    }

    It 'throws on an empty sentence' {
        $config = [ordered]@{ guids = [ordered]@{
                entry = [ordered]@{ guid = 'a1a7e577-ea70-0000-0000-000000000000'; description = 'x'; sentence = ' ' }
            }
        }
        { & $script:assert $config } | Should -Throw "*has an empty 'sentence'*"
    }

    It 'throws on an unknown entry key' {
        $config = [ordered]@{ guids = [ordered]@{
                entry = [ordered]@{ guid = 'a1a7e577-ea70-0000-0000-000000000000'; description = 'x'; owner = 'me' }
            }
        }
        { & $script:assert $config } | Should -Throw "*unknown key 'owner'*"
    }

    It 'throws on a non-map entry' {
        $config = [ordered]@{ guids = [ordered]@{ entry = 'a1a7e577-ea70-0000-0000-000000000000' } }
        { & $script:assert $config } | Should -Throw "*entry 'entry' must be a map*"
    }

    It 'collects all violations into one throw' {
        $config = [ordered]@{ guids = [ordered]@{
                one = [ordered]@{ description = 'x' }
                two = [ordered]@{ guid = 'not-a-guid'; description = 'y' }
            }
        }
        $thrown = $null
        try {
            & $script:assert $config
        }
        catch {
            $thrown = "$_"
        }
        $thrown | Should -Match "entry 'one' is missing 'guid'"
        $thrown | Should -Match "entry 'two' has invalid guid"
    }
}
