Describe 'Test-AzCliBicep' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-AzureBicepMinVersion { [version]'0.30.0' } -ModuleName Catzc.Azure.Cli
    }

    Context 'when az bicep version is at or above the minimum' {
        BeforeEach {
            Mock Invoke-AzCli {
                [pscustomobject]@{ Output = 'Bicep CLI version 0.43.8 (310735909d)'; ExitCode = 0 }
            } -ModuleName Catzc.Azure.Cli
        }

        It 'returns $true' {
            Test-AzCliBicep | Should -BeTrue
        }

        It 'probes via az bicep version' {
            Test-AzCliBicep | Out-Null
            Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Cli -ParameterFilter {
                $Arguments -match 'bicep version'
            }
        }
    }

    Context 'when az bicep version is below the minimum' {
        BeforeEach {
            Mock Invoke-AzCli {
                [pscustomobject]@{ Output = 'Bicep CLI version 0.20.0 (abcdef0123)'; ExitCode = 0 }
            } -ModuleName Catzc.Azure.Cli
        }

        It 'returns $false' {
            Test-AzCliBicep | Should -BeFalse
        }
    }

    Context 'when az bicep version exits non-zero (not installed)' {
        BeforeEach {
            Mock Invoke-AzCli {
                [pscustomobject]@{ Output = ''; ExitCode = 1 }
            } -ModuleName Catzc.Azure.Cli
        }

        It 'returns $false' {
            Test-AzCliBicep | Should -BeFalse
        }
    }
}
