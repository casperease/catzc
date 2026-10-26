<#
---
catzc:
  docs: "../../../../docs/references/pwsh/catzc-base-quality-gates/tests/types/GuidsConfig.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Catzc.Base.QualityGates.GuidsConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        # Built at runtime, since the all-zeros GUID is denied as a tracked literal.
        $script:zeroGuid = "$([guid]::Empty)"

        function New-GuidsConfig {
            param($Raw)
            [Catzc.Base.QualityGates.GuidsConfig]::new($Raw)
        }

        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] (New-GuidsConfig $Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the GuidsConfig constructor to throw'
        }
    }

    It 'accepts a well-formed registry' {
        $config = New-GuidsConfig ([ordered]@{ guids = [ordered]@{
                    ado_oauth_resource = [ordered]@{ guid = '499b84ac-1321-427f-aa17-267ca6975798'; description = 'ADO OAuth resource id' }
                    fixture_alpha      = [ordered]@{ guid = 'a100a000-7e57-7e0a-0700-000000000000'; description = 'alpha fixture tenant'; sentence = 'alpha test tenant' }
                }
            })
        @($config.guids.Keys) | Should -Be @('ado_oauth_resource', 'fixture_alpha')
        $config.guids['fixture_alpha'].sentence | Should -Be 'alpha test tenant'
        $config.guids['ado_oauth_resource'].Contains('sentence') | Should -BeFalse
    }

    It 'accepts an empty registry' {
        $config = New-GuidsConfig ([ordered]@{ guids = $null })
        $config.guids.Count | Should -Be 0
        $config.denied.Count | Should -Be 0
    }

    It 'accepts a registry with a denied section' {
        $config = New-GuidsConfig ([ordered]@{
                denied = [ordered]@{
                    guid_zero = [ordered]@{ guid = $script:zeroGuid; description = 'the unset value' }
                }
                guids  = [ordered]@{
                    entry = [ordered]@{ guid = 'a100a000-7e57-7e0a-0700-000000000000'; description = 'x' }
                }
            })
        $config.denied['guid_zero'].guid | Should -Be $script:zeroGuid
    }

    It 'throws when a denied guid is also registered' {
        Get-ViolationMessage ([ordered]@{
                denied = [ordered]@{
                    guid_zero = [ordered]@{ guid = $script:zeroGuid; description = 'the unset value' }
                }
                guids  = [ordered]@{
                    sneaky = [ordered]@{ guid = $script:zeroGuid; description = 'x' }
                }
            }) | Should -BeLike '*Duplicate guid value*denied value can never also be registered*'
    }

    It 'throws when a denied entry carries a sentence' {
        Get-ViolationMessage ([ordered]@{
                denied = [ordered]@{
                    guid_zero = [ordered]@{ guid = $script:zeroGuid; description = 'x'; sentence = 'zero' }
                }
                guids  = $null
            }) | Should -BeLike "*denied entry 'guid_zero' carries unknown key 'sentence'*"
    }

    It 'throws on an unknown top-level key' {
        Get-ViolationMessage ([ordered]@{ guids = $null; blocked = $null }) |
            Should -BeLike "*unknown top-level key 'blocked'*"
    }

    It 'throws when the guids key is missing' {
        Get-ViolationMessage ([ordered]@{ }) | Should -BeLike '*Missing required top-level key*'
    }

    It 'throws on a non-snake_case entry name' {
        Get-ViolationMessage ([ordered]@{ guids = [ordered]@{
                    'Bad-Name' = [ordered]@{ guid = 'a100a000-7e57-7e0a-0700-000000000000'; description = 'x' }
                }
            }) | Should -BeLike '*is invalid (must be snake_case*'
    }

    It 'throws on a missing guid' {
        Get-ViolationMessage ([ordered]@{ guids = [ordered]@{ entry = [ordered]@{ description = 'x' } } }) |
            Should -BeLike "*entry 'entry' is missing 'guid'*"
    }

    It 'throws on a non-canonical (uppercase) guid' {
        Get-ViolationMessage ([ordered]@{ guids = [ordered]@{
                    entry = [ordered]@{ guid = 'A100A000-7E57-7E0A-0700-000000000000'; description = 'x' }
                }
            }) | Should -BeLike '*canonical lowercase hyphenated form*'
    }

    It 'throws on a duplicate guid value' {
        Get-ViolationMessage ([ordered]@{ guids = [ordered]@{
                    one = [ordered]@{ guid = 'a100a000-7e57-7e0a-0700-000000000000'; description = 'x' }
                    two = [ordered]@{ guid = 'a100a000-7e57-7e0a-0700-000000000000'; description = 'y' }
                }
            }) | Should -BeLike '*Duplicate guid value*'
    }

    It 'throws on a missing description' {
        Get-ViolationMessage ([ordered]@{ guids = [ordered]@{
                    entry = [ordered]@{ guid = 'a100a000-7e57-7e0a-0700-000000000000' }
                }
            }) | Should -BeLike "*missing a non-empty 'description'*"
    }

    It 'throws on an empty sentence' {
        Get-ViolationMessage ([ordered]@{ guids = [ordered]@{
                    entry = [ordered]@{ guid = 'a100a000-7e57-7e0a-0700-000000000000'; description = 'x'; sentence = ' ' }
                }
            }) | Should -BeLike "*has an empty 'sentence'*"
    }

    It 'throws on an unknown entry key' {
        Get-ViolationMessage ([ordered]@{ guids = [ordered]@{
                    entry = [ordered]@{ guid = 'a100a000-7e57-7e0a-0700-000000000000'; description = 'x'; owner = 'me' }
                }
            }) | Should -BeLike "*unknown key 'owner'*"
    }

    It 'throws on a non-map entry' {
        Get-ViolationMessage ([ordered]@{ guids = [ordered]@{ entry = 'a100a000-7e57-7e0a-0700-000000000000' } }) |
            Should -BeLike "*entry 'entry' must be a map*"
    }

    It 'collects all violations into one throw' {
        $message = Get-ViolationMessage ([ordered]@{ guids = [ordered]@{
                    one = [ordered]@{ description = 'x' }
                    two = [ordered]@{ guid = 'not-a-guid'; description = 'y' }
                }
            })
        $message | Should -Match "entry 'one' is missing 'guid'"
        $message | Should -Match "entry 'two' has invalid guid"
    }
}
