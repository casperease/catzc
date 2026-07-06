Describe 'Initialize-GitClone' -Tag 'L0', 'logic' {
    # Every git invocation goes through Invoke-Executable, so one mock covers the whole external
    # boundary: rev-parse proves the work tree, `--get` probes report current values, and the
    # `git config --local <key>` writes are the side effects the tests count.
    BeforeEach {
        Mock Assert-Command { } -ModuleName Catzc.Tooling.Provisioning
        Mock Test-IsWslSession { $false } -ModuleName Catzc.Tooling.Provisioning
        Mock Invoke-Executable {
            switch -Regex ($Command) {
                'rev-parse --is-inside-work-tree' { [pscustomobject]@{ ExitCode = 0; Output = 'true' }; break }
                '--get user\.(name|email)' { [pscustomobject]@{ ExitCode = 0; Output = 'obj' }; break }
                '--get' { [pscustomobject]@{ ExitCode = 1; Output = '' }; break }   # local settings unset
                default { $null }
            }
        } -ModuleName Catzc.Tooling.Provisioning
    }

    It 'sets pull.rebase true when the clone does not have it' {
        Initialize-GitClone
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Provisioning -Times 1 -Exactly -ParameterFilter {
            $Command -eq 'git config --local pull.rebase "true"'
        }
    }

    It 'skips pull.rebase when it already holds the desired value' {
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = 'true' }
        } -ModuleName Catzc.Tooling.Provisioning -ParameterFilter { $Command -eq 'git config --local --get pull.rebase' }
        Initialize-GitClone
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Provisioning -Times 0 -ParameterFilter {
            $Command -like 'git config --local pull.rebase*'
        }
    }

    It 'in dry-run, returns the planned commands and writes nothing' {
        $planned = Initialize-GitClone -DryRun
        $planned | Should -Contain 'git config --local pull.rebase "true"'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Tooling.Provisioning -Times 0 -ParameterFilter {
            $Command -like 'git config --local pull.rebase*' -and $Command -notlike '*--get*'
        }
    }

    It 'throws when the path is not a git repository' {
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 128; Output = '' }
        } -ModuleName Catzc.Tooling.Provisioning -ParameterFilter { $Command -eq 'git rev-parse --is-inside-work-tree' }
        { Initialize-GitClone } | Should -Throw '*not a git repository*'
    }

    Context 'in a WSL session' {
        BeforeEach {
            Mock Test-IsWslSession { $true } -ModuleName Catzc.Tooling.Provisioning
        }

        It 'points credential.helper at the Windows credential manager, spaces escaped for sh' {
            Mock Find-WindowsGitCredentialManager {
                '/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe'
            } -ModuleName Catzc.Tooling.Provisioning
            $planned = Initialize-GitClone -DryRun
            $planned | Should -Contain 'git config --local credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"'
        }

        It 'leaves credential.helper unchanged when no Windows credential manager exists' {
            Mock Find-WindowsGitCredentialManager { $null } -ModuleName Catzc.Tooling.Provisioning
            $planned = Initialize-GitClone -DryRun
            $planned | Should -Not -Match 'credential\.helper'
            $planned | Should -Contain 'git config --local pull.rebase "true"'
        }
    }
}
