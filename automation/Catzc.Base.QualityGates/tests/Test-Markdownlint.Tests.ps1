<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1
    kind: test
---
#>

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
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
    }

    It 'passes and writes a report when markdownlint finds no issues' -Tag 'ADR-AUTO-TEST#35' {
        $script:markdownlintExit = 0
        { Test-Markdownlint -OutputFolder $script:reportBase } | Should -Not -Throw
        $result = Test-Markdownlint -OutputFolder $script:reportBase -PassThru
        $result.Subject | Should -Be 'markdownlint'
        $result.IssueCount | Should -Be 0
        $result.ExitCode | Should -Be 0
        (Join-Path $result.ReportPath 'markdownlint.md') | Should -Exist
    }

    It 'throws once listing every violation' -Tag 'ADR-AUTO-TEST#35' {
        $script:markdownlintExit = 1
        $script:markdownlintOut = ('docs/x.md:1:1 MD041/first-line-heading First line', 'docs/y.md:3:1 MD013/line-length Line length', '' -join "`n")
        $thrown = { Test-Markdownlint -OutputFolder $script:reportBase } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-Markdownlint failed: 2 issue(s)*'
        $message | Should -Match 'docs/x\.md:1:1 MD041/first-line-heading'
        $message | Should -Match 'docs/y\.md:3:1 MD013/line-length'
    }

    It 'with -PassThru returns the issues and file count instead of throwing' -Tag 'ADR-AUTO-TEST#35' {
        $script:markdownlintExit = 1
        $script:markdownlintOut = "a.md:1:1 MD013/line-length Line length`na.md:2:1 MD049/emphasis-style Emphasis`nb.md:2:3 MD040/fenced-code-language Fenced`n"
        $result = Test-Markdownlint -OutputFolder $script:reportBase -PassThru
        $result.IssueCount | Should -Be 3
        $result.FileCount | Should -Be 2
        $result.ExitCode | Should -Be 1
        (Get-Content (Join-Path $result.ReportPath 'markdownlint.md') -Raw) | Should -Match 'MD040'
    }

    It 'never passes a failing run whose output it cannot parse' {
        $script:markdownlintExit = 1
        $script:markdownlintOut = "Summary: 1 error(s)`n"
        { Test-Markdownlint -OutputFolder $script:reportBase } | Should -Throw '*markdownlint-cli2 exited 1 with no parsable violation line*'
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

    It 'passes the requested paths to markdownlint-cli2' {
        Test-Markdownlint -Path '**/*.md' -OutputFolder $script:reportBase | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match 'markdownlint-cli2' -and $Command -match '\*\*/\*\.md'
        }
    }

    It 'lints a long path list in batches, each batch carrying every exclusion' {
        $paths = @(1..120 | ForEach-Object { "gadget-$_.md" }) + '!widget'
        Test-Markdownlint -Path $paths -OutputFolder $script:reportBase | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 3 -Exactly -ParameterFilter { $Command -match "'!widget'" }
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
        $result = Test-Markdownlint -Path ($file -replace '\\', '/') -OutputFolder (Join-Path $TestDrive 'reports') -PassThru
        $result.IssueCount | Should -Be 0
    }
}

# Integrity: the ACTUAL repository markdown is lint-clean. Unlike the logic test above (real markdownlint over
# a fixture file), this binds to the real repo — Test-Markdownlint with no -Path scans its default content
# scope ([ADR-AUTO-TEST#14](/docs/adr/automation/test-automation.md#rule-adr-auto-test14)). L2 because it drives the
# markdownlint-cli2 CLI; self-skips when absent
# ([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)/9).
# Behind a protected glob ([ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)): a repeat local run over an
# unchanged 'markdown-scope' globset (the
# scan's inputs — in-scope markdown plus the markdownlint config) is skipped; in a pipeline the protection
# is ignored and the scan always runs full. source-only: it reads the repository's markdown, which gives the same
# answer in both run modes.
Describe 'Repository markdown integrity' -Tag 'L2', 'integrity', 'source-only' {
    It 'the real repository markdown is lint-clean (real markdownlint-cli2, default content scope)' {
        if (-not (Get-Command markdownlint-cli2 -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_markdownlint_missing'
            return
        }
        if (Test-GlobSetProtection -Test 'markdown' -Name 'markdown-scope') {
            Set-ItResult -Skipped -Because 'protected_globset_unchanged_since_green_run'
            return
        }
        (Test-Markdownlint -PassThru -OutputFolder (Join-Path $TestDrive 'markdownlint')).IssueCount | Should -Be 0
        Protect-GlobSet -Test 'markdown' -Name 'markdown-scope'
    }
}
