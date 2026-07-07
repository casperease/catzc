# cspell:ignore npsd  -- escape-sequence artifact in the "out/a`nb.tmp" fixture strings
# The non-git universe seam (ADR-GLOBS:11): `git ls-files --others` INCLUDING ignored files (D2), the
# 'filtered' companion source. Not reproducible — companion-only, never gated.
Describe 'Get-UntrackedFile' -Tag 'L0', 'logic' {
    It 'splits git output into paths and drops empty lines' {
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = "out/a.txt`nb.tmp`n`ngen/x.psd1`n"; ExitCode = 0 }
        } -ModuleName Catzc.Base.Globs

        InModuleScope Catzc.Base.Globs { Get-UntrackedFile } | Should -Be @('out/a.txt', 'b.tmp', 'gen/x.psd1')
    }

    It 'invokes git ls-files --others WITHOUT --exclude-standard, so ignored files are included (D2)' {
        Mock Invoke-Executable { [pscustomobject]@{ Output = "a`n"; ExitCode = 0 } } -ModuleName Catzc.Base.Globs

        InModuleScope Catzc.Base.Globs { Get-UntrackedFile } | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Globs -ParameterFilter {
            $Command -eq 'git -c core.quotepath=off ls-files --others' -and $Silent
        }
    }
}
