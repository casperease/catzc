# Validates the profiles.yml convention validator directly (private; via InModuleScope).
Describe 'Assert-ProfilesConfig' -Tag 'L0', 'logic' {
    It 'accepts a valid profiles map (including an empty seed)' {
        InModuleScope Catzc.Base.ModuleSystem {
            $config = [ordered]@{ profiles = [ordered]@{
                    minimal = @('Catzc.Base.Asserts')
                    azure   = @('Catzc.Azure.Cli', 'Catzc.Azure.Templates')
                    full    = @()
                }
            }
            { Assert-ProfilesConfig $config } | Should -Not -Throw
        }
    }

    It 'throws when profiles is missing or empty' {
        InModuleScope Catzc.Base.ModuleSystem {
            { Assert-ProfilesConfig ([ordered]@{}) } | Should -Throw '*profiles*'
            { Assert-ProfilesConfig ([ordered]@{ profiles = [ordered]@{} }) } | Should -Throw '*non-empty*'
        }
    }

    It 'throws on a non-snake_case profile name' {
        InModuleScope Catzc.Base.ModuleSystem {
            { Assert-ProfilesConfig ([ordered]@{ profiles = [ordered]@{ 'Bad-Name' = @('Catzc.Base.Asserts') } }) } |
                Should -Throw '*snake_case*'
        }
    }

    It 'throws when a profile is a single string, not a list' {
        InModuleScope Catzc.Base.ModuleSystem {
            { Assert-ProfilesConfig ([ordered]@{ profiles = [ordered]@{ minimal = 'Catzc.Base.Asserts' } }) } |
                Should -Throw '*list of module names*'
        }
    }
}
