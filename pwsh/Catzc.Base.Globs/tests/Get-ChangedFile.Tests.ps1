<#
---
catzc:
  immutable:
    with_body_sha: "38fe0db1f6c3"
  edges:
    docs: "[Get-ChangedFile.Tests.ps1.md](docs/references/pwsh/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Globs/private/Get-ChangedFile.ps1
    cites:
      - FDR-CD-GLOBS-TRACKEDFILESONLY
---
#>

# cspell:ignore nsrc  -- the escape-sequence artifact in the "a.txt`nsrc/b.cs" fixture strings
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
