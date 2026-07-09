Describe 'Test-Markdownlint' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:markdownlintExit = 0
        $script:markdownlintOut = ''
        $script:reportBase = Join-Path $TestDrive 'reports'

        # Mock the tool boundary — never launch a real process in a unit test.
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{
                ExitCode = $script:markdownlintExit
                Full     = $script:markdownlintOut
                Output   = $script:markdownlintOut
            }
        }
        Mock Test-Command -ModuleName Catzc.Base.QualityGates { $true }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
    }

    It 'returns clean (IssueCount 0) and writes a report when markdownlint finds no issues' {
        $script:markdownlintExit = 0
        $result = Test-Markdownlint -OutputFolder $script:reportBase -PassThru
        $result.IssueCount | Should -Be 0
        $result.ExitCode | Should -Be 0
        $result.ReportPath | Should -Exist
        (Join-Path $result.ReportPath 'markdownlint.md') | Should -Exist
    }

    It 'throws when markdownlint reports violations' {
        $script:markdownlintExit = 1
        $script:markdownlintOut = "docs/x.md:1:1 MD041/first-line-heading First line in a file should be a top-level heading`n"
        { Test-Markdownlint -OutputFolder $script:reportBase } | Should -Throw '*markdownlint issue*'
    }

    It 'with -PassThru returns the issue and file counts instead of throwing' {
        $script:markdownlintExit = 1
        $script:markdownlintOut = "a.md:1:1 MD013/line-length Line length`na.md:2:1 MD049/emphasis-style Emphasis`nb.md:2:3 MD040/fenced-code-language Fenced`n"
        $result = Test-Markdownlint -OutputFolder $script:reportBase -PassThru
        $result.IssueCount | Should -Be 3
        $result.FileCount | Should -Be 2
        $result.ExitCode | Should -Be 1
    }

    It 'writes the issues into the report file, not a console dump' {
        $script:markdownlintExit = 1
        $script:markdownlintOut = "docs/x.md:7:1 MD013/line-length Line length [Expected: 140; Actual: 180]`n"
        $result = Test-Markdownlint -OutputFolder $script:reportBase -PassThru
        (Get-Content (Join-Path $result.ReportPath 'markdownlint.md') -Raw) | Should -Match 'MD013'
        # Exactly one colored line (the report path) — issues are not dumped line-by-line to the console.
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $ForegroundColor -eq 'Cyan' }
    }

    It 'prints one console line per file with its issue count (count-descending)' {
        $script:markdownlintExit = 1
        $script:markdownlintOut = "a.md:1:1 MD013/line-length L`na.md:2:1 MD049/emphasis-style E`nb.md:2:3 MD040/fenced-code-language F`n"
        Test-Markdownlint -OutputFolder $script:reportBase -PassThru | Out-Null
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Message -eq 'a.md: 2' }
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Message -eq 'b.md: 1' }
    }

    It 'ignores banner lines that carry no MD rule id' {
        $script:markdownlintExit = 0
        $script:markdownlintOut = "markdownlint-cli2 v0.22.1 (markdownlint v0.40.0)`nFinding: **/*.md`nSummary: 0 error(s)`n"
        $result = Test-Markdownlint -OutputFolder $script:reportBase -PassThru
        $result.IssueCount | Should -Be 0
    }

    It 'throws a tool error when markdownlint exits greater than 1' {
        $script:markdownlintExit = 2
        $script:markdownlintOut = 'configuration error'
        { Test-Markdownlint -OutputFolder $script:reportBase } | Should -Throw '*markdownlint-cli2 failed*'
    }

    It 'passes the requested globs to markdownlint-cli2' {
        Test-Markdownlint -Glob '**/*.md' -OutputFolder $script:reportBase | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match 'markdownlint-cli2' -and $Command -match '\*\*/\*\.md'
        }
    }

    It 'excludes the out-of-scope trees via negation globs by default' {
        Test-Markdownlint -OutputFolder $script:reportBase | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match '!out' -and $Command -match '!docs/notes' -and $Command -match '!automation/\.vendor'
        }
    }

    It 'throws an actionable error when markdownlint-cli2 is not installed' {
        Mock Test-Command -ModuleName Catzc.Base.QualityGates { $false }
        { Test-Markdownlint -OutputFolder $script:reportBase } | Should -Throw '*Install-Markdownlint*'
    }
}

Describe 'Test-Markdownlint (real markdownlint-cli2)' -Tag 'L2', 'logic' {
    It 'reports no issues on a compliant file' {
        if (-not (Get-Command markdownlint-cli2 -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_markdownlint_missing'
            return
        }
        $file = Join-Path $TestDrive 'clean.md'
        Set-Content -Path $file -Value @('# Title', '', 'A short compliant paragraph.') -Encoding utf8
        $glob = $file -replace '\\', '/'
        $result = Test-Markdownlint -Glob $glob -OutputFolder (Join-Path $TestDrive 'reports') -PassThru
        $result.IssueCount | Should -Be 0
    }
}

# Integrity: the ACTUAL repository markdown is lint-clean. Unlike the logic test above (real markdownlint over
# a fixture file), this binds to the real repo — Test-Markdownlint with no -Glob scans its default content
# scope (ADR-AUTO-TEST:14). L2 because it drives the markdownlint-cli2 CLI; self-skips when absent (ADR-AUTO-TEST:8/9).
# Protected-glob gated (ADR-REPO-PROTGLOB): a repeat local run over an unchanged 'markdown-scope' globset (the
# scan's inputs — in-scope markdown plus the markdownlint config) is skipped; in a pipeline the protection
# is ignored and the scan always runs full.
Describe 'Repository markdown integrity' -Tag 'L2', 'integrity' {
    It 'the real repository markdown is lint-clean (real markdownlint-cli2, default content scope)' {
        if (-not (Get-Command markdownlint-cli2 -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_markdownlint_missing'
            return
        }
        if (Test-GlobSetProtection -Test 'markdown' -Name 'markdown-scope') {
            Set-ItResult -Skipped -Because 'protected_globset_unchanged_since_green_run'
            return
        }
        { Test-Markdownlint -OutputFolder (Join-Path $TestDrive 'reports') } | Should -Not -Throw
        Protect-GlobSet -Test 'markdown' -Name 'markdown-scope'
    }
}
