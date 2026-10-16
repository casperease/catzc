<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Git/tests/Push-Dirty.Tests.ps1
    folder: tests
    name: push-dirty-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Git
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Push-Dirty' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Assert-Command { } -ModuleName Catzc.Base.Git
        Mock Write-Message { } -ModuleName Catzc.Base.Git
        Mock Test-GitWorkspace { $false } -ModuleName Catzc.Base.Git
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = "main`n" }
        } -ModuleName Catzc.Base.Git -ParameterFilter { $Command -eq 'git rev-parse --abbrev-ref HEAD' }
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = " M widget.txt`n" }
        } -ModuleName Catzc.Base.Git -ParameterFilter { $Command -eq 'git status --porcelain' }
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = '' }
        } -ModuleName Catzc.Base.Git -ParameterFilter { $Command -eq 'git add -A' -or $Command -like 'git commit -m *' }
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = '' }
        } -ModuleName Catzc.Base.Git -ParameterFilter { $Command -like 'git push *' }
    }

    It 'stages, commits with "..." when no message is given, and pushes the current branch' {
        Push-Dirty
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter { $Command -eq 'git add -A' }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter { $Command -eq 'git commit -m "..."' }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter { $Command -eq 'git push origin main' }
    }

    It 'commits with "..." when the message is empty or blank' {
        Push-Dirty -Message '  '
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter { $Command -eq 'git commit -m "..."' }
    }

    It 'commits with the given message' {
        Push-Dirty -Message 'Fix the widget'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter { $Command -eq 'git commit -m "Fix the widget"' }
    }

    It 'escapes a double quote in the message' {
        Push-Dirty -Message 'the "gadget"'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter { $Command -eq 'git commit -m "the \"gadget\""' }
    }

    It 'pushes without committing when the tree is clean' {
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = '' }
        } -ModuleName Catzc.Base.Git -ParameterFilter { $Command -eq 'git status --porcelain' }
        Push-Dirty
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 0 -ParameterFilter { $Command -eq 'git add -A' -or $Command -like 'git commit *' }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter { $Command -eq 'git push origin main' }
    }

    It 'stops on main in main-via-pr and changes nothing' {
        Mock Test-GitWorkspace { $true } -ModuleName Catzc.Base.Git
        { Push-Dirty } | Should -Throw '*main-via-pr*'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 0 -ParameterFilter { $Command -eq 'git add -A' -or $Command -like 'git push *' }
    }

    It 'pushes a branch in main-via-pr' {
        Mock Test-GitWorkspace { $true } -ModuleName Catzc.Base.Git
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = "topic`n" }
        } -ModuleName Catzc.Base.Git -ParameterFilter { $Command -eq 'git rev-parse --abbrev-ref HEAD' }
        Push-Dirty
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 1 -Exactly -ParameterFilter { $Command -eq 'git push origin topic' }
    }

    It 'refuses a detached HEAD' {
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = "HEAD`n" }
        } -ModuleName Catzc.Base.Git -ParameterFilter { $Command -eq 'git rev-parse --abbrev-ref HEAD' }
        { Push-Dirty } | Should -Throw '*detached*'
    }

    It 'reports a rejected push, keeps the commit, and never forces' {
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 1; Output = 'rejected' }
        } -ModuleName Catzc.Base.Git -ParameterFilter { $Command -like 'git push *' }
        { Push-Dirty } | Should -Throw '*Push rejected*'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 0 -ParameterFilter { $Command -like '*--force*' -or $Command -like '* -f *' }
    }

    It 'in dry-run, reports the plan and runs no mutating git command' {
        $planned = Push-Dirty -DryRun
        $planned.Branch | Should -Be 'main'
        $planned.HasChanges | Should -BeTrue
        $planned.Message | Should -Be '...'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Git -Times 0 -ParameterFilter { $Command -eq 'git add -A' -or $Command -like 'git commit *' -or $Command -like 'git push *' }
    }
}
