BeforeAll {
    Import-InternalModule TestKit
    Import-InternalModule Builder
}

Describe 'Get-BuildSourceStamp' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:root = Join-Path $TestDrive 'widget-repo'
        [System.IO.Directory]::CreateDirectory($script:root) | Out-Null
    }

    It 'stamps the same tree the same' {
        $first = InModuleScope Catzc.Internal.Builder -Parameters @{ Root = $script:root } {
            Mock Invoke-Executable {
                $listed = if ($Command -like '*ls-files -s') {
                    "100644 abc123 0`tpwsh/Widget/Get-Widget.ps1"
                }
                else {
                    ''
                }
                [pscustomobject] @{ ExitCode = 0; Output = $listed; Errors = '' }
            }
            Get-BuildSourceStamp -RepositoryRoot $Root -Selection 'gadgets|1.0.0|widget'
        }
        $second = InModuleScope Catzc.Internal.Builder -Parameters @{ Root = $script:root } {
            Mock Invoke-Executable {
                $listed = if ($Command -like '*ls-files -s') {
                    "100644 abc123 0`tpwsh/Widget/Get-Widget.ps1"
                }
                else {
                    ''
                }
                [pscustomobject] @{ ExitCode = 0; Output = $listed; Errors = '' }
            }
            Get-BuildSourceStamp -RepositoryRoot $Root -Selection 'gadgets|1.0.0|widget'
        }
        $first | Should -Not -BeNullOrEmpty
        $second | Should -Be $first
    }

    It 'throws naming the <Listing> listing when git exits non-zero for it' -ForEach @(
        @{ Listing = 'modified'; Failing = '*ls-files -m' }
        @{ Listing = 'untracked'; Failing = '*ls-files --others*' }
    ) {
        InModuleScope Catzc.Internal.Builder -Parameters @{ Root = $script:root; Failing = $Failing; Listing = $Listing } {
            Mock Invoke-Executable {
                $failed = $Command -like $Failing
                [pscustomobject] @{ ExitCode = [int] $failed; Output = ''; Errors = $(if ($failed) {
                            'widget listing failed'
                        }
                        else {
                            ''
                        })
                }
            }
            { Get-BuildSourceStamp -RepositoryRoot $Root -Selection 'gadgets|1.0.0|widget' } | Should -Throw "*cannot list the $Listing files*widget listing failed*"
        }
    }
}
