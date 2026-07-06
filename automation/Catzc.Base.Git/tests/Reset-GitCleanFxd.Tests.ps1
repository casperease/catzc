Describe 'Reset-GitCleanFxd' -Tag 'L0', 'logic' {
    # git's own dry-run listing is the one external boundary (plus the deleting clean calls); the
    # whitelist itself is mocked to a fixed set so these tests exercise pure classification logic.
    BeforeEach {
        Mock Assert-Command { } -ModuleName Catzc.Base.Git
        Mock Get-AutoControlledGlobs { @('out', 'out/*', '*/README.md', '.vscode', '.vscode/*') } -ModuleName Catzc.Base.Git
        Mock Write-Message { } -ModuleName Catzc.Base.Git
        Mock Invoke-Executable {
            [pscustomobject]@{
                ExitCode = 0
                Output   = "Would remove out/report.csv`nWould remove automation/Catzc.Base.Git/README.md`nWould remove .vscode/`nWould remove New-Draft.ps1"
            }
        } -ModuleName Catzc.Base.Git -ParameterFilter { $Command -eq 'git clean -xdn' }
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = '' }
        } -ModuleName Catzc.Base.Git -ParameterFilter { $Command -like 'git clean -fxd -- *' }
    }

    It 'deletes only the auto-controlled candidates, pathspec-limited' {
        Reset-GitCleanFxd
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter {
            $Command -eq 'git clean -fxd -- "out/report.csv" "automation/Catzc.Base.Git/README.md" ".vscode"'
        }
    }

    It 'keeps and reports the untracked file that is not auto-controlled' {
        Reset-GitCleanFxd
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 0 -ParameterFilter {
            $Command -like 'git clean -fxd*' -and $Command -like '*New-Draft.ps1*'
        }
        Should -Invoke Write-Message -ModuleName Catzc.Base.Git -Times 1 -ParameterFilter {
            $Message -like "Kept 'New-Draft.ps1'*"
        }
    }

    It 'in dry-run, returns the Remove/Keep plan and deletes nothing' {
        $planned = Reset-GitCleanFxd -DryRun
        @($planned.Remove) | Should -Be @('out/report.csv', 'automation/Catzc.Base.Git/README.md', '.vscode')
        @($planned.Keep) | Should -Be @('New-Draft.ps1')
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 0 -ParameterFilter { $Command -like 'git clean -fxd*' }
    }

    It 'reports a clean tree and runs no clean at all' {
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = '' }
        } -ModuleName Catzc.Base.Git -ParameterFilter { $Command -eq 'git clean -xdn' }
        Reset-GitCleanFxd | Should -BeNullOrEmpty
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 0 -ParameterFilter { $Command -like 'git clean -fxd*' }
        Should -Invoke Write-Message -ModuleName Catzc.Base.Git -Times 1 -ParameterFilter { $Message -like '*already clean*' }
    }

    It 'batches a large controlled set into several pathspec-limited clean calls' {
        $lines = @(1..60 | ForEach-Object { "Would remove out/file$_.txt" }) -join "`n"
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = $lines }
        } -ModuleName Catzc.Base.Git -ParameterFilter { $Command -eq 'git clean -xdn' }
        Reset-GitCleanFxd
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 3 -Exactly -ParameterFilter { $Command -like 'git clean -fxd -- *' }
    }
}
