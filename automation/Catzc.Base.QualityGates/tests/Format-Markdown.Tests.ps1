Describe 'Format-Markdown' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:prettierExit = 0
        $script:prettierOut = ''

        # Mock the tool boundary — never launch a real process in a unit test.
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{
                ExitCode = $script:prettierExit
                Full     = $script:prettierOut
                Output   = $script:prettierOut
            }
        }
        Mock Test-Command -ModuleName Catzc.Base.QualityGates { $true }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
    }

    It 'is reachable via the Invoke-MarkdownPrettier alias' {
        (Get-Alias Invoke-MarkdownPrettier -ErrorAction Ignore).Definition | Should -Be 'Format-Markdown'
    }

    It 'in --write mode counts only the changed files (those without "(unchanged)")' {
        $script:prettierExit = 0
        $script:prettierOut = "a.md 10ms`nb.md 5ms (unchanged)`nc.md 12ms`n"
        $result = Format-Markdown -PassThru
        $result.ChangedCount | Should -Be 2
        $result.ChangedFiles | Should -Be @('a.md', 'c.md')
        $result.DryRun | Should -BeFalse
    }

    It 'reports zero changes when every file is unchanged' {
        $script:prettierOut = "a.md 10ms (unchanged)`nb.md 5ms (unchanged)`n"
        $result = Format-Markdown -PassThru
        $result.ChangedCount | Should -Be 0
    }

    It 'in -DryRun mode returns the would-change files from --list-different' {
        $script:prettierExit = 1
        $script:prettierOut = "a.md`nc.md`n"
        $result = Format-Markdown -DryRun -PassThru
        $result.ChangedCount | Should -Be 2
        $result.ChangedFiles | Should -Be @('a.md', 'c.md')
        $result.DryRun | Should -BeTrue
    }

    It '-DryRun calls prettier with --list-different and does not write' {
        Format-Markdown -DryRun | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match 'prettier' -and $Command -match '--list-different' -and $Command -notmatch '--write'
        }
    }

    It 'default (write) mode calls prettier with --write' {
        Format-Markdown | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match '--write' -and $Command -notmatch '--list-different'
        }
    }

    It '-Check calls prettier with --check and does not write' {
        Format-Markdown -Check | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match 'prettier' -and $Command -match '--check' -and $Command -notmatch '--write'
        }
    }

    It '-Check returns the unformatted files and surfaces Prettier warnings, dropping the summary line' {
        $script:prettierExit = 1
        $script:prettierOut = "Checking formatting...`n[warn] a.md`n[warn] c.md`n[warn] Code style issues found in 2 files. Run Prettier with --write to fix.`n"
        $result = Format-Markdown -Check -PassThru
        $result.ChangedCount | Should -Be 2
        $result.ChangedFiles | Should -Be @('a.md', 'c.md')
        $result.Check | Should -BeTrue
        $result.DryRun | Should -BeFalse
        # Warnings keep the raw [warn] lines (including the summary), unlike ChangedFiles.
        $result.Warnings.Count | Should -Be 3
        $result.Warnings | Should -Contain '[warn] a.md'
    }

    It '-Check strips ANSI colour codes from Prettier warning lines' {
        $script:prettierExit = 1
        $esc = [char]27
        # Build the SGR codes via variables so the raw test text never places the colour byte immediately
        # before 'warn' as a single token, which the spell-checker would flag.
        $color = "$esc[33m"
        $reset = "$esc[39m"
        $script:prettierOut = "Checking formatting...`n[${color}warn${reset}] a.md`n"
        $result = Format-Markdown -Check -PassThru
        $result.ChangedFiles | Should -Be @('a.md')
        $result.Warnings | Should -Be @('[warn] a.md')
    }

    It '-Check reports clean when prettier finds no style issues' {
        $script:prettierExit = 0
        $script:prettierOut = "Checking formatting...`nAll matched files use Prettier code style!`n"
        $result = Format-Markdown -Check -PassThru
        $result.ChangedCount | Should -Be 0
        $result.Warnings.Count | Should -Be 0
    }

    It '-Check supersedes -DryRun when both are given (uses --check)' {
        Format-Markdown -Check -DryRun | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match '--check' -and $Command -notmatch '--list-different'
        }
    }

    It 'passes the requested globs to prettier' {
        Format-Markdown -Glob '**/*.md' | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match '\*\*/\*\.md'
        }
    }

    It 'excludes the content-scope trees by default (out/, docs/notes)' {
        Format-Markdown | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match "'!out'" -and $Command -match "'!docs/notes'"
        }
    }

    It 'throws a tool error when prettier exits greater than 1' {
        $script:prettierExit = 2
        $script:prettierOut = 'some prettier error'
        { Format-Markdown } | Should -Throw '*Prettier failed*'
    }

    It 'throws an actionable error when prettier is not installed' {
        Mock Test-Command -ModuleName Catzc.Base.QualityGates { $false }
        { Format-Markdown } | Should -Throw '*Install-Prettier*'
    }
}

Describe 'Format-Markdown (real prettier)' -Tag 'L2', 'logic' {
    It 'formats a poorly-wrapped Markdown file so Prettier then reports it clean' {
        if (-not (Get-Command prettier -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_prettier_missing'
            return
        }
        $file = Join-Path $TestDrive 'doc.md'
        # A heading plus an over-long single-line paragraph (>140) that proseWrap: always will rewrap.
        $long = '# Title' + "`n`n" + ('word ' * 60).Trim() + '.'
        Set-Content -Path $file -Value $long -Encoding utf8
        $glob = $file -replace '\\', '/'
        $result = Format-Markdown -Glob $glob -PassThru
        $result.ChangedCount | Should -Be 1
        # After formatting, prettier --list-different reports nothing to change.
        $again = Format-Markdown -Glob $glob -DryRun -PassThru
        $again.ChangedCount | Should -Be 0
    }
}
