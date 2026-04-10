# cspell:ignore mispeld
Describe 'Test-Spelling' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:cspellExit = 0
        $script:cspellOut = 'CSpell: Files checked: 12, Issues found: 0 in 0 files.'
        $script:reportBase = Join-Path $TestDrive 'reports'

        # Mock the tool boundary — never launch a real process in a unit test.
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{
                ExitCode = $script:cspellExit
                Full     = $script:cspellOut
                Output   = $script:cspellOut
            }
        }
        Mock Test-Command -ModuleName Catzc.Base.QualityGates { $true }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
    }

    It 'returns clean (IssueCount 0) and writes a report when cspell finds no issues' {
        $result = Test-Spelling -OutputFolder $script:reportBase -PassThru
        $result.IssueCount | Should -Be 0
        $result.ExitCode | Should -Be 0
        $result.ReportPath | Should -Exist
        (Join-Path $result.ReportPath 'spelling.md') | Should -Exist
    }

    It 'throws when cspell reports spelling issues' {
        $script:cspellExit = 1
        $script:cspellOut = "docs/x.md:1:1 - Unknown word (mispeld) fix: (misspelled)`nCSpell: Files checked: 1, Issues found: 1 in 1 file."
        { Test-Spelling -OutputFolder $script:reportBase } | Should -Throw '*spelling issue*'
    }

    It 'with -PassThru returns the issue and file counts from cspell''s summary' {
        $script:cspellExit = 1
        $script:cspellOut = "a.md:1:1 - Unknown word (foo)`na.md:2:1 - Unknown word (baz)`nb.ps1:2:3 - Unknown word (bar)`nCSpell: Files checked: 5, Issues found: 3 in 2 files."
        $result = Test-Spelling -OutputFolder $script:reportBase -PassThru
        $result.IssueCount | Should -Be 3
        $result.FileCount | Should -Be 2
        $result.ExitCode | Should -Be 1
    }

    It 'prints one console line per file with its issue count (count-descending)' {
        $script:cspellExit = 1
        $script:cspellOut = "a.md:1:1 - Unknown word (foo)`na.md:2:1 - Unknown word (baz)`nb.ps1:2:3 - Unknown word (bar)`nCSpell: Files checked: 5, Issues found: 3 in 2 files."
        Test-Spelling -OutputFolder $script:reportBase -PassThru | Out-Null
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Message -eq 'a.md: 2' }
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Message -eq 'b.ps1: 1' }
    }

    It 'writes the issues into the report file, not a console dump' {
        $script:cspellExit = 1
        $script:cspellOut = "docs/x.md:1:1 - Unknown word (mispeld) fix: (misspelled)`nCSpell: Files checked: 1, Issues found: 1 in 1 file."
        $result = Test-Spelling -OutputFolder $script:reportBase -PassThru
        (Get-Content (Join-Path $result.ReportPath 'spelling.md') -Raw) | Should -Match 'mispeld'
        # Exactly one colored line (the report path) — issues are not dumped line-by-line to the console.
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $ForegroundColor -eq 'Cyan' }
    }

    It 'throws "no files" when the globs match nothing' {
        $script:cspellExit = 1
        $script:cspellOut = 'CSpell: Files checked: 0, Issues found: 0 in 0 files.'
        { Test-Spelling -OutputFolder $script:reportBase } | Should -Throw '*matched no files*'
    }

    It 'throws a tool error when cspell exits greater than 1' {
        $script:cspellExit = 2
        $script:cspellOut = 'configuration error'
        { Test-Spelling -OutputFolder $script:reportBase } | Should -Throw '*cspell failed*'
    }

    It 'passes the repo config and the requested globs to cspell' {
        Test-Spelling -Glob '**/*.md' -OutputFolder $script:reportBase | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match 'lint' -and $Command -match 'cspell\.yml' -and $Command -match '\*\*/\*\.md'
        }
    }

    It 'passes the content-scope excludes to cspell as --exclude globs' {
        Test-Spelling -OutputFolder $script:reportBase | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match "--exclude 'out/\*\*'" -and $Command -match "--exclude 'docs/notes/\*\*'"
        }
    }

    It 'passes a custom -Exclude through to cspell and omits the defaults' {
        Test-Spelling -Exclude 'foo/**' -OutputFolder $script:reportBase | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match "--exclude 'foo/\*\*'" -and $Command -notmatch "--exclude 'out/\*\*'"
        }
    }

    It 'throws an actionable error when cspell is not installed' {
        Mock Test-Command -ModuleName Catzc.Base.QualityGates { $false }
        { Test-Spelling -OutputFolder $script:reportBase } | Should -Throw '*Install-Cspell*'
    }
}

Describe 'Test-Spelling (real cspell)' -Tag 'L2', 'logic' {
    It 'reports no issues on a correctly spelled file and writes a report' {
        if (-not (Get-Command cspell -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_cspell_missing'
            return
        }
        # cspell globs are relative to the repo root (Test-Spelling's working directory), so use the
        # committed clean fixture by its repo-relative path.
        $glob = 'automation/Catzc.Base.QualityGates/tests/assets/spelling/clean.md'
        $result = Test-Spelling -Glob $glob -OutputFolder (Join-Path $TestDrive 'reports') -PassThru
        $result.IssueCount | Should -Be 0
        (Join-Path $result.ReportPath 'spelling.md') | Should -Exist
    }
}

# Integrity: the ACTUAL repository content is spell-clean. Unlike the logic test above (real cspell over a
# fixture file), this binds to the real repo — Test-Spelling with no -Glob scans its default content scope
# (ADR-TEST:14). L2 because it drives the cspell CLI; self-skips when cspell is absent (ADR-TEST:8/9).
Describe 'Repository spelling integrity' -Tag 'L2', 'integrity' {
    It 'the real repository content is spell-clean (real cspell, default content scope)' {
        if (-not (Get-Command cspell -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_cspell_missing'
            return
        }
        { Test-Spelling -OutputFolder (Join-Path $TestDrive 'reports') } | Should -Not -Throw
    }
}
