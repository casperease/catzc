<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Write-TestAutomationReport.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Write-TestAutomationReport.Tests.ps1.md
      source: automation/Catzc.Base.QualityGates/private/Write-TestAutomationReport.ps1
---
#>

Describe 'Write-TestAutomationReport' -Tag 'L0', 'logic' {
    BeforeAll {
        function New-Row {
            param($Path, $Result, $Ms, $Level, $File, $Line, $Message, $Stack, $Rules = '')
            [pscustomobject]@{
                ExpandedPath = $Path
                ExpandedName = ($Path -split '\.')[-1]
                Result       = $Result
                DurationMs   = $Ms
                Level        = $Level
                Category     = 'logic'
                Rules        = $Rules
                File         = $File
                Line         = $Line
                ErrorMessage = "$Message"
                ErrorStack   = "$Stack"
                SkipReason   = ''
            }
        }

        Mock Get-TestTimeLimits -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ LevelMs = @{ L0 = 400; L1 = 2000; L2 = 30000; L3 = 120000 }; RunSeconds = 120 }
        }

        $script:rows = @(
            New-Row -Path 'Mod.Fast passes' -Result 'Passed' -Ms 50 -Level 'L1' -File 'C:\x\Fast.Tests.ps1' -Line 5 `
                -Rules 'ADR-WIDGET-GADGET#3'
            New-Row -Path 'Mod.Slow is slow' -Result 'Passed' -Ms 130000 -Level 'L2' -File 'C:\x\Slow.Tests.ps1' -Line 9
            New-Row -Path 'Mod.Broken fails' -Result 'Failed' -Ms 10 -Level 'L1' -File 'C:\x\Broken.Tests.ps1' -Line 12 `
                -Message 'Expected 1 but got 2' -Stack 'at <ScriptBlock>, C:\x\Broken.Tests.ps1: line 12'
        )
    }

    It 'writes summary.md with counts, the failure (file:line + message), slowest, and over-limit timings' {
        $dir = Join-Path $TestDrive 'run-md'
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $dir; R = $script:rows } {
            param($Dir, $R)
            Write-TestAutomationReport -Rows $R -OutputFolder $Dir -Level 2 -RunResult 'Failed' -DurationSeconds 130.06
        }

        $md = Get-Content (Join-Path $dir 'summary.md') -Raw
        $md | Should -Match '- Result: Failed'
        $md | Should -Match '- Duration: 130\.06s'
        $md | Should -Match '\| 3 \| 2 \| 1 \| 0 \| 0 \|'      # counts row, derived from the rows
        $md | Should -Match '## Failures \(1\)'
        $md | Should -Match 'Mod\.Broken fails'
        $md | Should -Match 'Broken\.Tests\.ps1:12'             # file:line
        $md | Should -Match 'Expected 1 but got 2'              # message
        $md | Should -Match '## Slowest tests'
        $md | Should -Match 'Mod\.Slow is slow'
        $md | Should -Match '\[L2 > 30000ms\]'                  # over-limit against the configured tier limit, report-only
        $md | Should -Match '- Run budget: 120s — exceeded by 10\.06s \(fails a devbox run' # the run against its configured budget
    }

    It 'records a run inside its budget' {
        $dir = Join-Path $TestDrive 'run-within'
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $dir; R = $script:rows } {
            param($Dir, $R)
            Write-TestAutomationReport -Rows $R -OutputFolder $Dir -Level 2 -RunResult 'Failed' -DurationSeconds 119
        }

        (Get-Content (Join-Path $dir 'summary.md') -Raw) | Should -Match '- Run budget: 120s — within'
    }

    It 'writes tests.csv with one row per test, slowest first' {
        $dir = Join-Path $TestDrive 'run-csv'
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $dir; R = $script:rows } {
            param($Dir, $R)
            Write-TestAutomationReport -Rows $R -OutputFolder $Dir -Level 2 -RunResult 'Failed'
        }

        $csv = Import-Csv (Join-Path $dir 'tests.csv')
        $csv | Should -HaveCount 3
        $csv[0].DurationMs | Should -Be '130000'               # slowest first
        $csv[0].Level | Should -Be 'L2'
        ($csv | Where-Object { $_.Result -eq 'Failed' }).ExpandedPath | Should -Be 'Mod.Broken fails'
        # Rules is the backtrack column: filter tests.csv by a citation to find its enforcing tests.
        ($csv | Where-Object { $_.Rules -eq 'ADR-WIDGET-GADGET#3' }).ExpandedPath | Should -Be 'Mod.Fast passes'
    }

    It 'annotates the over-limit section as enforced when -TimingsEnforced' {
        $dir = Join-Path $TestDrive 'run-enforced'
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $dir; R = $script:rows } {
            param($Dir, $R)
            Write-TestAutomationReport -Rows $R -OutputFolder $Dir -Level 2 -RunResult 'Failed' -TimingsEnforced
        }

        (Get-Content (Join-Path $dir 'summary.md') -Raw) | Should -Match 'Over-limit timings \(1\) \[enforced'
    }
}
