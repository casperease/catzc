Describe 'Set-BicepTrackingTagSet' -Tag 'L0', 'logic' {
    BeforeEach {
        # Discover from the test fixtures, never the shipped infrastructure/templates.
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
    }

    Context 'devbox' {
        BeforeEach {
            Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Azure.Templates
            Mock Get-GitCurrentCommit { 'abc1234567890abc1234567890abc1234567890a' } -ModuleName Catzc.Azure.Templates
            Mock Get-GitCurrentBranch { 'feature/devbox' } -ModuleName Catzc.Azure.Templates
            Mock Invoke-AzCli {
                [pscustomobject]@{ Output = 'name: result'; ExitCode = 0 }
            } -ModuleName Catzc.Azure.Templates
        }

        It 'builds the resource id from subscription + the derived resource group for RG-target' {
            Set-BicepTrackingTagSet -Environment alpha -Template sample | Out-Null
            Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -ParameterFilter {
                $Arguments -match '^tag update' -and
                $Arguments -match '--operation Merge' -and
                $Arguments -match '/subscriptions/[0-9a-f-]+/resourceGroups/alpha-weu-tst-smpl-rg'
            }
        }

        It 'uses generic tag names for RG-target' {
            Set-BicepTrackingTagSet -Environment alpha -Template sample | Out-Null
            Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -ParameterFilter {
                $Arguments -match 'Deployed_From_Commit=abc1234567890abc1234567890abc1234567890a' -and
                $Arguments -match 'Deployed_From_BuildId=CLI_NO_BUILD' -and
                $Arguments -match 'Deployed_From_Branch=feature/devbox'
            }
        }

        It '-DryRun does not call az' {
            Set-BicepTrackingTagSet -Environment alpha -Template sample -DryRun
            Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -Times 0
        }

        It 'tags the slot-derived resource group for a special slot' {
            Set-BicepTrackingTagSet -Environment alpha -Template sample-indexed -Slot 001 | Out-Null
            Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -ParameterFilter {
                $Arguments -match '/resourceGroups/alpha-001-weu-tst-sidx-rg'
            }
        }
    }

    Context 'failure surfacing' {
        BeforeEach {
            Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Azure.Templates
            Mock Get-GitCurrentCommit { 'abc1234567890abc1234567890abc1234567890a' } -ModuleName Catzc.Azure.Templates
            Mock Get-GitCurrentBranch { 'feature/devbox' } -ModuleName Catzc.Azure.Templates
        }

        It 'throws once (no retry) on a non-zero exit, carrying the scope and az stderr' {
            Mock Invoke-AzCli {
                [pscustomobject]@{
                    Output   = ''
                    Errors   = "('Connection aborted.', RemoteDisconnected('Remote end closed connection without response'))"
                    ExitCode = 1
                }
            } -ModuleName Catzc.Azure.Templates

            $err = { Set-BicepTrackingTagSet -Environment alpha -Template sample } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike '*Failed to write tracking tags*'
            $err.Exception.Message | Should -BeLike '*alpha-weu-tst-smpl-rg*'
            $err.Exception.Message | Should -BeLike '*Connection aborted*'
            $err.Exception.Message | Should -BeLike '*exited 1*'
            Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -Times 1
        }

        It 'includes the az command line in the thrown error' {
            Mock Invoke-AzCli {
                [pscustomobject]@{ Output = ''; Errors = 'RequestDisallowedByPolicy'; ExitCode = 1 }
            } -ModuleName Catzc.Azure.Templates

            $err = { Set-BicepTrackingTagSet -Environment alpha -Template sample } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike '*az tag update --operation Merge*'
            $err.Exception.Message | Should -BeLike '*RequestDisallowedByPolicy*'
        }
    }

    Context 'pipeline' {
        BeforeEach {
            Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Azure.Templates
            Mock Invoke-AzCli {
                [pscustomobject]@{ Output = 'name: result'; ExitCode = 0 }
            } -ModuleName Catzc.Azure.Templates

            $script:origCommit = $env:BUILD_SOURCEVERSION
            $script:origBuildId = $env:BUILD_BUILDID
            $script:origBranch = $env:BUILD_SOURCEBRANCH
            $env:BUILD_SOURCEVERSION = 'deadbeef1234567890deadbeef1234567890dead'
            $env:BUILD_BUILDID = '4242'
            $env:BUILD_SOURCEBRANCH = 'refs/heads/main'
        }

        AfterEach {
            $env:BUILD_SOURCEVERSION = $script:origCommit
            $env:BUILD_BUILDID = $script:origBuildId
            $env:BUILD_SOURCEBRANCH = $script:origBranch
        }

        It 'uses ADO env vars for tag values' {
            Set-BicepTrackingTagSet -Environment alpha -Template sample | Out-Null
            Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Templates -ParameterFilter {
                $Arguments -match 'Deployed_From_Commit=deadbeef1234567890deadbeef1234567890dead' -and
                $Arguments -match 'Deployed_From_BuildId=4242' -and
                $Arguments -match 'Deployed_From_Branch=refs/heads/main'
            }
        }
    }
}
