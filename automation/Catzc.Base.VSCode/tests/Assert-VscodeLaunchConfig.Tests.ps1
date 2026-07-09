# Assert-VscodeLaunchConfig is private, so it is exercised through the module (ADR-AUTO-PESTER:4).
Describe 'Assert-VscodeLaunchConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:assert = {
            param($Config)
            InModuleScope Catzc.Base.VSCode -Parameters @{ C = $Config } { param($C) Assert-VscodeLaunchConfig -Config $C }
        }
        $script:valid = {
            [ordered]@{
                version        = '0.2.0'
                configurations = @(
                    [ordered]@{ name = 'Fixture'; type = 'PowerShell'; request = 'launch' }
                )
            }
        }
    }

    It 'accepts a well-formed registry' {
        { & $script:assert (& $script:valid) } | Should -Not -Throw
    }

    It 'throws when version is missing or blank' {
        $config = & $script:valid
        $config.Remove('version')
        { & $script:assert $config } | Should -Throw "*'version' must be a non-empty string*"
    }

    It 'throws when configurations is missing or empty' {
        { & $script:assert ([ordered]@{ version = '0.2.0'; configurations = @() }) } |
            Should -Throw '*non-empty list of launch profiles*'
    }

    It 'throws when a profile lacks name, type, or request' {
        $config = & $script:valid
        $config['configurations'] = @([ordered]@{ name = 'X'; type = 'PowerShell' })
        { & $script:assert $config } | Should -Throw "*missing a non-empty 'request'*"
    }

    It 'throws on duplicate profile names' {
        $config = & $script:valid
        $config['configurations'] = @(
            [ordered]@{ name = 'Same'; type = 'PowerShell'; request = 'launch' }
            [ordered]@{ name = 'Same'; type = 'PowerShell'; request = 'attach' }
        )
        { & $script:assert $config } | Should -Throw "*duplicate configuration name 'Same'*"
    }
}
