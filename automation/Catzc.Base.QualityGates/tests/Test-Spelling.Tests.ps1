<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1
    kind: pester-test
---
#>

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
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
    }

    It 'passes and writes a report when cspell finds no issues' -Tag 'ADR-AUTO-TEST#35' {
        { Test-Spelling -OutputFolder $script:reportBase } | Should -Not -Throw
        $result = Test-Spelling -OutputFolder $script:reportBase -PassThru
        $result.Subject | Should -Be 'spelling'
        $result.IssueCount | Should -Be 0
        $result.ExitCode | Should -Be 0
        (Join-Path $result.ReportPath 'spelling.md') | Should -Exist
    }

    It 'throws once listing every issue line, so each misspelled word is named' -Tag 'ADR-AUTO-TEST#35' {
        $script:cspellExit = 1
        $script:cspellOut = (@(
                'a.md:1:1 - Unknown word (mispeld) fix: (misspelled)'
                'b.md:2:1 - Unknown word (bravo)'
                'CSpell: Files checked: 2, Issues found: 2 in 2 files.'
            ) -join "`n")
        $thrown = { Test-Spelling -OutputFolder $script:reportBase } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-Spelling failed: 2 issue(s)*'
        $message | Should -Match 'a\.md:1:1 - Unknown word \(mispeld\)'
        $message | Should -Match 'b\.md:2:1 - Unknown word \(bravo\)'
    }

    It 'with -PassThru returns the issues and the file count from cspell''s summary' -Tag 'ADR-AUTO-TEST#35' {
        $script:cspellExit = 1
        $script:cspellOut = "a.md:1:1 - Unknown word (foo)`na.md:2:1 - Unknown word (baz)`nb.ps1:2:3 - Unknown word (bar)`nCSpell: Files checked: 5, Issues found: 3 in 2 files."
        $result = Test-Spelling -OutputFolder $script:reportBase -PassThru
        $result.IssueCount | Should -Be 3
        $result.FileCount | Should -Be 2
        $result.ExitCode | Should -Be 1
        (Get-Content (Join-Path $result.ReportPath 'spelling.md') -Raw) | Should -Match 'b\.ps1:2:3 - Unknown word \(bar\)'
    }

    It 'checks a long path list in batches, one cspell call each, and merges their issues' -Tag 'ADR-AUTO-TEST#35' {
        $script:cspellExit = 1
        $script:cspellOut = "widget.md:1:1 - Unknown word (foo)`nCSpell: Files checked: 50, Issues found: 1 in 1 files."
        $paths = 1..120 | ForEach-Object { "gadget-$_.md" }
        $result = Test-Spelling -Path $paths -OutputFolder $script:reportBase -PassThru
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 3 -Exactly
        $result.IssueCount | Should -Be 3
        $result.ExitCode | Should -Be 1
    }

    It 'never passes a failing cspell run whose output it cannot parse' {
        $script:cspellExit = 1
        $script:cspellOut = 'CSpell: Files checked: 3, something new happened'
        { Test-Spelling -OutputFolder $script:reportBase } | Should -Throw '*cspell exited 1 with no parsable issue line*'
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

    It 'passes the repo config and the requested paths to cspell' {
        Test-Spelling -Path '**/*.md' -OutputFolder $script:reportBase | Out-Null
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
        $fixture = 'automation/Catzc.Base.QualityGates/tests/assets/spelling/clean.md'
        $result = Test-Spelling -Path $fixture -OutputFolder (Join-Path $TestDrive 'reports') -PassThru
        $result.IssueCount | Should -Be 0
        (Join-Path $result.ReportPath 'spelling.md') | Should -Exist
    }
}

# Integrity: the ACTUAL repository content is spell-clean. Unlike the logic test above (real cspell over a
# fixture file), this binds to the real repo — Test-Spelling with no -Path scans its default content scope
# ([ADR-AUTO-TEST#14](/docs/adr/automation/test-automation.md#rule-adr-auto-test14)). L2 because it drives the cspell
# CLI; self-skips when cspell is absent
# ([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)/9).
# Behind a protected glob ([ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)): a repeat local run over an
# unchanged 'repository' globset
# (every tracked file under every named root — a covering superset of cspell's content scope and its
# own configs) is skipped; in a pipeline the protection is ignored and the scan always runs full. source-only: it
# reads the repository's files, which give the same answer in both run modes.
Describe 'Repository spelling integrity' -Tag 'L2', 'integrity', 'source-only' {
    It 'the repository globset covers every tracked file the spelling scan reads' -Tag 'ADR-REPO-PROTGLOB#6' {
        # The spelling scan's default content types; cspell.yml ignorePaths drops vendored code. Any such
        # tracked file outside repository could change the scan's outcome without re-keying protection.
        $spelledExtensions = @('.md', '.ps1', '.psm1', '.psd1', '.yml', '.yaml', '.json', '.cs', '.bicep', '.go', '.py')
        $spelled = foreach ($file in (Get-GitTrackedPath '.')) {
            if ($file.StartsWith('automation/.vendor/')) {
                continue
            }
            if ([System.IO.Path]::GetExtension($file).ToLowerInvariant() -in $spelledExtensions) {
                $file
            }
        }
        $members = [System.Collections.Generic.HashSet[string]]::new([string[]]@(Get-GlobSetFile -Name 'repository'), [System.StringComparer]::Ordinal)
        $uncovered = @($spelled | Where-Object { -not $members.Contains($_) })
        $uncovered | Should -BeNullOrEmpty -Because 'every file the spelling scan reads must re-key its protection identity (globs.yml repository)'
    }

    It 'the real repository content is spell-clean (real cspell, default content scope)' {
        if (-not (Get-Command cspell -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_cspell_missing'
            return
        }
        if (Test-GlobSetProtection -Test 'spelling' -Name 'repository') {
            Set-ItResult -Skipped -Because 'protected_globset_unchanged_since_green_run'
            return
        }
        (Test-Spelling -PassThru -OutputFolder (Join-Path $TestDrive 'spelling')).IssueCount | Should -Be 0
        Protect-GlobSet -Test 'spelling' -Name 'repository'
    }
}
