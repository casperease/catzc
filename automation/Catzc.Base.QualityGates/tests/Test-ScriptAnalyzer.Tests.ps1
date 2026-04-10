Describe 'Test-ScriptAnalyzer' -Tag 'L0', 'logic' {
    BeforeAll {
        # A real file so the -Path collection (Resolve-Path) resolves; the analysis helper is mocked, so the
        # file's contents are irrelevant.
        $script:targetFile = Join-Path $TestDrive 'subject.ps1'
        Set-Content -Path $script:targetFile -Value 'function Get-Thing { }' -Encoding utf8
    }

    BeforeEach {
        $script:diagnostics = @()
        $script:reportBase = Join-Path $TestDrive 'reports'

        # Mock the analysis boundary — the sharded background-job runner — never run the real (slow) analyzer
        # in a unit test. (Start-Job processes cannot see Pester mocks, so the seam is the helper, not the
        # cmdlet inside it; the helper has its own L2 real-analyzer coverage below.)
        Mock Get-ScriptAnalyzerDiagnostics -ModuleName Catzc.Base.QualityGates { $script:diagnostics }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
    }

    It 'returns clean (IssueCount 0) and writes a report when the analyzer finds no violations' {
        $result = Test-ScriptAnalyzer -Path $script:targetFile -OutputFolder $script:reportBase -PassThru
        $result.IssueCount | Should -Be 0
        $result.FileCount | Should -Be 0
        $result.ReportPath | Should -Exist
        (Join-Path $result.ReportPath 'scriptanalyzer.md') | Should -Exist
    }

    It 'throws when the analyzer reports violations' {
        $script:diagnostics = @(
            [pscustomobject]@{ ScriptPath = 'C:\repo\a.ps1'; Line = 3; Column = 5; Severity = 'Warning'; RuleName = 'PSAvoidUsingCmdletAliases'; Message = 'Avoid alias' }
        )
        { Test-ScriptAnalyzer -Path $script:targetFile -OutputFolder $script:reportBase } |
            Should -Throw '*PSScriptAnalyzer violation*'
    }

    It 'with -PassThru returns the violation and file counts instead of throwing' {
        $script:diagnostics = @(
            [pscustomobject]@{ ScriptPath = 'C:\repo\a.ps1'; Line = 1; Column = 1; Severity = 'Warning'; RuleName = 'PSUseConsistentIndentation'; Message = 'Indent' }
            [pscustomobject]@{ ScriptPath = 'C:\repo\a.ps1'; Line = 2; Column = 1; Severity = 'Warning'; RuleName = 'PSPlaceOpenBrace'; Message = 'Brace' }
            [pscustomobject]@{ ScriptPath = 'C:\repo\b.ps1'; Line = 9; Column = 3; Severity = 'Error'; RuleName = 'PSAvoidExclaimOperator'; Message = 'Bang' }
        )
        $result = Test-ScriptAnalyzer -Path $script:targetFile -OutputFolder $script:reportBase -PassThru
        $result.IssueCount | Should -Be 3
        $result.FileCount | Should -Be 2
    }

    It 'writes the violations into the report file, not a console dump' {
        $script:diagnostics = @(
            [pscustomobject]@{ ScriptPath = 'C:\repo\a.ps1'; Line = 7; Column = 1; Severity = 'Warning'; RuleName = 'PSUseConsistentWhitespace'; Message = 'Whitespace' }
        )
        $result = Test-ScriptAnalyzer -Path $script:targetFile -OutputFolder $script:reportBase -PassThru
        (Get-Content (Join-Path $result.ReportPath 'scriptanalyzer.md') -Raw) | Should -Match 'PSUseConsistentWhitespace'
        # Exactly one coloured line (the report path) — violations are not dumped line-by-line to the console.
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $ForegroundColor -eq 'Cyan' }
    }

    It 'prints one console line per file with its violation count (count-descending)' {
        $script:diagnostics = @(
            [pscustomobject]@{ ScriptPath = 'C:\repo\a.ps1'; Line = 1; Column = 1; Severity = 'Warning'; RuleName = 'R1'; Message = 'm' }
            [pscustomobject]@{ ScriptPath = 'C:\repo\a.ps1'; Line = 2; Column = 1; Severity = 'Warning'; RuleName = 'R2'; Message = 'm' }
            [pscustomobject]@{ ScriptPath = 'C:\repo\b.ps1'; Line = 9; Column = 3; Severity = 'Warning'; RuleName = 'R3'; Message = 'm' }
        )
        Test-ScriptAnalyzer -Path $script:targetFile -OutputFolder $script:reportBase -PassThru | Out-Null
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Message -eq 'a.ps1: 2' }
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Message -eq 'b.ps1: 1' }
    }

    It 'analyzes with the repo PSScriptAnalyzerSettings.psd1' {
        Test-ScriptAnalyzer -Path $script:targetFile -OutputFolder $script:reportBase | Out-Null
        Should -Invoke Get-ScriptAnalyzerDiagnostics -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $SettingsPath -match 'PSScriptAnalyzerSettings\.psd1'
        }
    }
}

# 'logic' (not 'integrity') and self-contained fixtures, matching the 'Format-Markdown (real
# prettier)' sibling: this exercises the gate against the REAL analyzer over throwaway files, it does not
# assert a repo-wide fact. The repo-wide "all module code is analyzer-clean" integrity check is already the
# sharded L2 'PSScriptAnalyzer' test in automation/.internal/tests — not duplicated here.
Describe 'Test-ScriptAnalyzer (real analyzer)' -Tag 'L2', 'logic' {
    It 'reports a clean fixture as having no violations (real PSScriptAnalyzer, repo rule set)' {
        $file = Join-Path $TestDrive 'Get-Thing.ps1'
        Set-Content -Path $file -Value "function Get-Thing {`n    `$value = 1`n    `$value`n}" -Encoding utf8
        $result = Test-ScriptAnalyzer -Path $file -OutputFolder (Join-Path $TestDrive 'reports') -PassThru
        $result.IssueCount | Should -Be 0
    }

    It 'flags a real violation (an aliased cmdlet) and throws' {
        $file = Join-Path $TestDrive 'Get-Bad.ps1'
        # gci is the Get-ChildItem alias — PSAvoidUsingCmdletAliases (enabled in the repo psd1) flags it.
        Set-Content -Path $file -Value "function Get-Bad {`n    gci`n}" -Encoding utf8
        { Test-ScriptAnalyzer -Path $file -OutputFolder (Join-Path $TestDrive 'reports') } |
            Should -Throw '*PSScriptAnalyzer violation*'
    }
}
