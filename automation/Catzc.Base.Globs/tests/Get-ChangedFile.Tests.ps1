# cspell:ignore nsrc  -- the escape-sequence artifact in the "a.txt`nsrc/b.cs" fixture strings
# The diff universe (ADR-GLOBS:4): changed paths from `git diff --name-only --no-renames`, repo-relative,
# quotepath off, renames split so both the old and new path count.
Describe 'Get-ChangedFile' -Tag 'L0', 'logic' {
    It 'splits git diff output into paths and drops empty lines' {
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = "a.txt`nsrc/b.cs`n`nsrc/c.cs`n"; ExitCode = 0 }
        } -ModuleName Catzc.Base.Globs

        $files = InModuleScope Catzc.Base.Globs { Get-ChangedFile -Range 'HEAD^1..HEAD' }
        $files | Should -Be @('a.txt', 'src/b.cs', 'src/c.cs')
    }

    It 'handles CRLF-separated output' {
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = "a.txt`r`nb.txt`r`n"; ExitCode = 0 }
        } -ModuleName Catzc.Base.Globs

        InModuleScope Catzc.Base.Globs { Get-ChangedFile -Range 'x..y' } | Should -Be @('a.txt', 'b.txt')
    }

    It 'diffs the given range with quotepath off and renames split, silently' {
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = "a.txt`n"; ExitCode = 0 }
        } -ModuleName Catzc.Base.Globs

        InModuleScope Catzc.Base.Globs { Get-ChangedFile -Range 'origin/main...HEAD' } | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Globs -ParameterFilter {
            $Command -eq 'git -c core.quotepath=off diff --name-only --no-renames origin/main...HEAD' -and $Silent
        }
    }
}
