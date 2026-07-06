Describe 'Assert-GuidsConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:assert = {
            param($Config)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ C = $Config } { param($C) Assert-GuidsConfig -Config $C }
        }
        # The all-zeros GUID is itself denied (it must not appear as a tracked literal), so build it at
        # runtime — the same discipline the managed-guid gate enforces on every other file.
        $script:zeroGuid = "$([guid]::Empty)"
    }

    It 'accepts a well-formed registry' {
        $config = [ordered]@{ guids = [ordered]@{
                ado_oauth_resource = [ordered]@{ guid = '499b84ac-1321-427f-aa17-267ca6975798'; description = 'ADO OAuth resource id' }
                fixture_alpha      = [ordered]@{ guid = 'a100a000-7e57-7e0a-0700-000000000000'; description = 'alpha fixture tenant'; sentence = 'alpha test tenant' }
            }
        }
        { & $script:assert $config } | Should -Not -Throw
    }

    It 'accepts an empty registry' {
        { & $script:assert ([ordered]@{ guids = $null }) } | Should -Not -Throw
    }

    It 'accepts a registry with a denied section' {
        $config = [ordered]@{
            denied = [ordered]@{
                guid_zero = [ordered]@{ guid = $script:zeroGuid; description = 'the unset value' }
            }
            guids  = [ordered]@{
                entry = [ordered]@{ guid = 'a100a000-7e57-7e0a-0700-000000000000'; description = 'x' }
            }
        }
        { & $script:assert $config } | Should -Not -Throw
    }

    It 'throws when a denied guid is also registered' {
        $config = [ordered]@{
            denied = [ordered]@{
                guid_zero = [ordered]@{ guid = $script:zeroGuid; description = 'the unset value' }
            }
            guids  = [ordered]@{
                sneaky = [ordered]@{ guid = $script:zeroGuid; description = 'x' }
            }
        }
        { & $script:assert $config } | Should -Throw '*Duplicate guid value*denied value can never also be registered*'
    }

    It 'throws when a denied entry carries a sentence' {
        $config = [ordered]@{
            denied = [ordered]@{
                guid_zero = [ordered]@{ guid = $script:zeroGuid; description = 'x'; sentence = 'zero' }
            }
            guids  = $null
        }
        { & $script:assert $config } | Should -Throw "*denied entry 'guid_zero' carries unknown key 'sentence'*"
    }

    It 'throws on an unknown top-level key' {
        $config = [ordered]@{ guids = $null; blocked = $null }
        { & $script:assert $config } | Should -Throw "*unknown top-level key 'blocked'*"
    }

    It 'throws when the guids key is missing' {
        { & $script:assert ([ordered]@{ }) } | Should -Throw '*Missing required top-level key*'
    }

    It 'throws on a non-snake_case entry name' {
        $config = [ordered]@{ guids = [ordered]@{
                'Bad-Name' = [ordered]@{ guid = 'a100a000-7e57-7e0a-0700-000000000000'; description = 'x' }
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
                entry = [ordered]@{ guid = 'A100A000-7E57-7E0A-0700-000000000000'; description = 'x' }
            }
        }
        { & $script:assert $config } | Should -Throw '*canonical lowercase hyphenated form*'
    }

    It 'throws on a duplicate guid value' {
        $config = [ordered]@{ guids = [ordered]@{
                one = [ordered]@{ guid = 'a100a000-7e57-7e0a-0700-000000000000'; description = 'x' }
                two = [ordered]@{ guid = 'a100a000-7e57-7e0a-0700-000000000000'; description = 'y' }
            }
        }
        { & $script:assert $config } | Should -Throw '*Duplicate guid value*'
    }

    It 'throws on a missing description' {
        $config = [ordered]@{ guids = [ordered]@{
                entry = [ordered]@{ guid = 'a100a000-7e57-7e0a-0700-000000000000' }
            }
        }
        { & $script:assert $config } | Should -Throw "*missing a non-empty 'description'*"
    }

    It 'throws on an empty sentence' {
        $config = [ordered]@{ guids = [ordered]@{
                entry = [ordered]@{ guid = 'a100a000-7e57-7e0a-0700-000000000000'; description = 'x'; sentence = ' ' }
            }
        }
        { & $script:assert $config } | Should -Throw "*has an empty 'sentence'*"
    }

    It 'throws on an unknown entry key' {
        $config = [ordered]@{ guids = [ordered]@{
                entry = [ordered]@{ guid = 'a100a000-7e57-7e0a-0700-000000000000'; description = 'x'; owner = 'me' }
            }
        }
        { & $script:assert $config } | Should -Throw "*unknown key 'owner'*"
    }

    It 'throws on a non-map entry' {
        $config = [ordered]@{ guids = [ordered]@{ entry = 'a100a000-7e57-7e0a-0700-000000000000' } }
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
