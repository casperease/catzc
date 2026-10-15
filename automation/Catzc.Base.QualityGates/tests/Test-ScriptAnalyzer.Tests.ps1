<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1
    kind: pester-test
---
#>

Describe 'Test-ScriptAnalyzer' -Tag 'L0', 'logic' {
    BeforeAll {
        # A real file so the -Path collection (Resolve-Path) resolves; the analysis helper is mocked, so the
        # file's contents are irrelevant.
        $script:targetFile = Join-Path $TestDrive 'subject.ps1'
        Set-Content -Path $script:targetFile -Value 'function Get-Thing { }' -Encoding utf8

        # Mock the analysis boundary — the sharded background-job runner — never run the real (slow) analyzer
        # in a unit test. (Start-Job processes cannot see Pester mocks, so the seam is the helper, not the
        # cmdlet inside it; the helper has its own L2 real-analyzer coverage below.) Mocked once for the block:
        # each case sets $script:diagnostics for the mock to return.
        Mock Get-ScriptAnalyzerDiagnostics -ModuleName Catzc.Base.QualityGates { $script:diagnostics }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
    }

    BeforeEach {
        $script:diagnostics = @()
        $script:reportBase = Join-Path $TestDrive 'reports'
    }

    It 'resolves a relative -Path against the repository root, never the working directory' -Tag 'ADR-AUTO-NOPWD#1' {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $TestDrive }
        $elsewhere = Join-Path $TestDrive 'elsewhere'
        [void][System.IO.Directory]::CreateDirectory($elsewhere)
        Push-Location -LiteralPath $elsewhere
        try {
            Test-ScriptAnalyzer -Path 'subject.ps1' -OutputFolder $script:reportBase -PassThru | Out-Null
        }
        finally {
            Pop-Location
        }
        Should -Invoke Get-ScriptAnalyzerDiagnostics -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            @($Path).Count -eq 1 -and $Path[0] -eq [System.IO.Path]::GetFullPath($script:targetFile)
        }
    }

    It 'passes and writes a report when the analyzer finds no violations' -Tag 'ADR-AUTO-TEST#35' {
        { Test-ScriptAnalyzer -Path $script:targetFile -OutputFolder $script:reportBase } | Should -Not -Throw
        $result = Test-ScriptAnalyzer -Path $script:targetFile -OutputFolder $script:reportBase -PassThru
        $result.Subject | Should -Be 'script-analyzer'
        $result.IssueCount | Should -Be 0
        $result.FileCount | Should -Be 0
        (Join-Path $result.ReportPath 'script-analyzer.md') | Should -Exist
    }

    It 'throws once listing every violation' -Tag 'ADR-AUTO-TEST#35' {
        $script:diagnostics = @(
            [pscustomobject]@{ ScriptPath = 'repo/a.ps1'; Line = 3; Column = 5; Severity = 'Warning'; RuleName = 'PSAvoidUsingCmdletAliases'; Message = 'Avoid alias' }
            [pscustomobject]@{ ScriptPath = 'repo/b.ps1'; Line = 9; Column = 3; Severity = 'Error'; RuleName = 'PSAvoidExclaimOperator'; Message = 'Bang' }
        )
        $thrown = { Test-ScriptAnalyzer -Path $script:targetFile -OutputFolder $script:reportBase } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-ScriptAnalyzer failed: 2 issue(s)*'
        $message | Should -Match 'repo/a\.ps1:3:5 Warning PSAvoidUsingCmdletAliases Avoid alias'
        $message | Should -Match 'repo/b\.ps1:9:3 Error PSAvoidExclaimOperator Bang'
    }

    It 'with -PassThru returns the violation and file counts instead of throwing' -Tag 'ADR-AUTO-TEST#35' {
        $script:diagnostics = @(
            [pscustomobject]@{ ScriptPath = 'repo/a.ps1'; Line = 1; Column = 1; Severity = 'Warning'; RuleName = 'PSUseConsistentIndentation'; Message = 'Indent' }
            [pscustomobject]@{ ScriptPath = 'repo/a.ps1'; Line = 2; Column = 1; Severity = 'Warning'; RuleName = 'PSPlaceOpenBrace'; Message = 'Brace' }
            [pscustomobject]@{ ScriptPath = 'repo/b.ps1'; Line = 9; Column = 3; Severity = 'Error'; RuleName = 'PSAvoidExclaimOperator'; Message = 'Bang' }
        )
        $result = Test-ScriptAnalyzer -Path $script:targetFile -OutputFolder $script:reportBase -PassThru
        $result.IssueCount | Should -Be 3
        $result.FileCount | Should -Be 2
    }

    It 'writes the violations into the report file, sorted by file, line, and column' {
        $script:diagnostics = @(
            [pscustomobject]@{ ScriptPath = 'repo/b.ps1'; Line = 2; Column = 1; Severity = 'Warning'; RuleName = 'PSPlaceOpenBrace'; Message = 'Brace' }
            [pscustomobject]@{ ScriptPath = 'repo/a.ps1'; Line = 7; Column = 1; Severity = 'Warning'; RuleName = 'PSUseConsistentWhitespace'; Message = 'Whitespace' }
        )
        $result = Test-ScriptAnalyzer -Path $script:targetFile -OutputFolder $script:reportBase -PassThru
        (Get-Content (Join-Path $result.ReportPath 'script-analyzer.md') -Raw) | Should -Match 'PSUseConsistentWhitespace'
        $result.Issues[0] | Should -BeLike 'repo/a.ps1:7:1 *'
    }

    It 'analyzes with the repo PSScriptAnalyzerSettings.psd1' {
        Test-ScriptAnalyzer -Path $script:targetFile -OutputFolder $script:reportBase | Out-Null
        Should -Invoke Get-ScriptAnalyzerDiagnostics -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $SettingsPath -match 'PSScriptAnalyzerSettings\.psd1'
        }
    }
}

# The real-asset test of
# [ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3): the gate runs over
# throwaway files with nothing mocked, so it reads
# the shipped settings file (<code root>/.internal/assets/PSScriptAnalyzerSettings.psd1) and the vendored
# analyzer (<code root>/.vendor) — integrity, and not source-only, so it runs in the source and the build run.
# The repo-wide "all module code is analyzer-clean" check is the sharded L2 'PSScriptAnalyzer' test in
# automation/.internal/tests — not duplicated here.
# greedy: the real analyzer fans out Start-Job pwsh processes of its own — stacked on the parallel pool
# that oversubscribes the box (see the test-automation ADR's greedy tag).
Describe 'Test-ScriptAnalyzer (real analyzer)' -Tag 'L2', 'integrity', 'greedy', 'ADR-AUTO-ASSETDEP#3' {
    # One real-analyzer run over a clean + a violating file proves the boundary end-to-end: the real analyzer
    # flags the aliased cmdlet with the repo rule set and reports the clean file as issue-free. The throw path
    # (IssueCount > 0 without -PassThru) is pure Test-ScriptAnalyzer logic, covered by the mocked L0 block above;
    # here -PassThru surfaces the real counts without re-spawning the analyzer shards a second time.
    It 'flags a real aliased-cmdlet violation and passes the clean fixture (real PSScriptAnalyzer, repo rule set)' {
        $clean = Join-Path $TestDrive 'Get-Thing.ps1'
        Set-Content -Path $clean -Value "function Get-Thing {`n    `$value = 1`n    `$value`n}" -Encoding utf8
        $bad = Join-Path $TestDrive 'Get-Bad.ps1'
        # gci is the Get-ChildItem alias — PSAvoidUsingCmdletAliases (enabled in the repo psd1) flags it.
        Set-Content -Path $bad -Value "function Get-Bad {`n    gci`n}" -Encoding utf8

        $result = Test-ScriptAnalyzer -Path @($clean, $bad) -OutputFolder (Join-Path $TestDrive 'reports') -PassThru

        $result.IssueCount | Should -BeGreaterThan 0
        $result.FileCount | Should -Be 1   # only the violating file has issues; the clean one contributes none
        (Get-Content (Join-Path $result.ReportPath 'script-analyzer.md') -Raw) | Should -Match 'PSAvoidUsingCmdletAliases'
    }
}
