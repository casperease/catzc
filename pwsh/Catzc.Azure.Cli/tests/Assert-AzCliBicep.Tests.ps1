Describe 'Assert-AzCliBicep' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-AzureBicepMinVersion { [version]'0.30.0' } -ModuleName Catzc.Azure.Cli
        # Assert-AzCliBicep asserts az itself is available first; keep this L2 test hermetic.
        Mock Assert-Tool { } -ModuleName Catzc.Azure.Cli
    }

    Context 'when the Bicep CLI meets the minimum' {
        BeforeEach {
            Mock Invoke-AzCli {
                [pscustomobject]@{ Output = 'Bicep CLI version 0.43.8 (310735909d)'; ExitCode = 0 }
            } -ModuleName Catzc.Azure.Cli
        }

        It 'does not throw' {
            { Assert-AzCliBicep } | Should -Not -Throw
        }
    }

    Context 'when the Bicep CLI is not installed' {
        BeforeEach {
            Mock Invoke-AzCli {
                [pscustomobject]@{ Output = ''; ExitCode = 1 }
            } -ModuleName Catzc.Azure.Cli
        }

        It 'throws with an az bicep install remediation hint' {
            { Assert-AzCliBicep } | Should -Throw '*az bicep install*'
        }
    }

    Context 'when the Bicep CLI is below the minimum' {
        BeforeEach {
            Mock Invoke-AzCli {
                [pscustomobject]@{ Output = 'Bicep CLI version 0.20.0 (abcdef0123)'; ExitCode = 0 }
            } -ModuleName Catzc.Azure.Cli
        }

        It 'throws naming the version, the minimum, and an az bicep upgrade hint' {
            { Assert-AzCliBicep } | Should -Throw '*0.20.0*0.30.0*az bicep upgrade*'
        }
    }

    Context 'when the Bicep CLI version cannot be parsed' {
        BeforeEach {
            Mock Invoke-AzCli {
                [pscustomobject]@{ Output = 'unexpected output'; ExitCode = 0 }
            } -ModuleName Catzc.Azure.Cli
        }

        It 'throws an az bicep upgrade hint' {
            { Assert-AzCliBicep } | Should -Throw '*Could not determine the Bicep CLI version*az bicep upgrade*'
        }
    }

    Context 'with a custom ErrorText' {
        BeforeEach {
            Mock Invoke-AzCli {
                [pscustomobject]@{ Output = ''; ExitCode = 1 }
            } -ModuleName Catzc.Azure.Cli
        }

        It 'throws the custom message' {
            { Assert-AzCliBicep -ErrorText 'custom boom' } | Should -Throw 'custom boom'
        }
    }
}
