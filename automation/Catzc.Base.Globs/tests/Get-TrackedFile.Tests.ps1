# cspell:ignore nsrc  -- the escape-sequence artifact in the "a.txt`nsrc/b.cs" fixture strings
# The matching universe (ADR-GLOBS:4): tracked files from `git ls-files`, repo-relative, quotepath off.
Describe 'Get-TrackedFile' -Tag 'L0', 'logic' {
    It 'splits git output into paths and drops empty lines' {
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = "a.txt`nsrc/b.cs`n`nsrc/c.cs`n"; ExitCode = 0 }
        } -ModuleName Catzc.Base.Globs

        $files = InModuleScope Catzc.Base.Globs { Get-TrackedFile }
        $files | Should -Be @('a.txt', 'src/b.cs', 'src/c.cs')
    }

    It 'handles CRLF-separated output' {
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = "a.txt`r`nb.txt`r`n"; ExitCode = 0 }
        } -ModuleName Catzc.Base.Globs

        InModuleScope Catzc.Base.Globs { Get-TrackedFile } | Should -Be @('a.txt', 'b.txt')
    }

    It 'invokes git ls-files with quotepath off, silently' {
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = "a.txt`n"; ExitCode = 0 }
        } -ModuleName Catzc.Base.Globs

        InModuleScope Catzc.Base.Globs { Get-TrackedFile } | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Globs -ParameterFilter {
            $Command -eq 'git -c core.quotepath=off ls-files' -and $Silent
        }
    }
}

# The real boundary, integration-tested: this repository's own tracked files come back repo-relative with
# forward slashes, including this test file.
Describe 'Get-TrackedFile (real git)' -Tag 'L2', 'integrity' {
    It 'lists this repository''s tracked files as /-separated repo-relative paths' {
        $files = InModuleScope Catzc.Base.Globs { Get-TrackedFile }
        $files.Count | Should -BeGreaterThan 100
        $files | Should -Contain 'importer.ps1'
        ($files | Where-Object { $_ -like '*\*' }).Count | Should -Be 0
    }
}
