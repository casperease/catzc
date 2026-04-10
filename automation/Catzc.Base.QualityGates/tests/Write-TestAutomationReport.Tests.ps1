Describe 'Write-TestAutomationReport' -Tag 'L0', 'logic' {
    BeforeAll {
        # Build a Pester-shaped test-result object without running Pester: just the members the report
        # reads (Result, Duration, ExpandedPath/Name, ErrorRecord, the Block tag chain, ScriptBlock file/line).
        function New-FakeTest {
            param($Path, $Result, $Ms, $Level, $File, $Line, $Message)
            $block = [pscustomobject]@{
                Tag    = @($Level)
                IsRoot = $false
                Parent = [pscustomobject]@{ IsRoot = $true; Tag = @() }
            }
            $err = if ($Message) {
                [pscustomobject]@{
                    Exception        = [pscustomobject]@{ Message = $Message }
                    ScriptStackTrace = "at <ScriptBlock>, ${File}: line $Line"
                }
            }
            else {
                @()
            }
            [pscustomobject]@{
                Result       = $Result
                Duration     = [timespan]::FromMilliseconds($Ms)
                ExpandedPath = $Path
                ExpandedName = ($Path -split '\.')[-1]
                ErrorRecord  = $err
                Block        = $block
                ScriptBlock  = [pscustomobject]@{
                    File          = $File
                    StartPosition = [pscustomobject]@{ StartLine = $Line }
                }
            }
        }

        $script:result = [pscustomobject]@{
            Result       = 'Failed'
            TotalCount   = 3
            PassedCount  = 2
            FailedCount  = 1
            SkippedCount = 0
            NotRunCount  = 0
            Duration     = [timespan]::FromSeconds(130.06)
            Tests        = @(
                New-FakeTest -Path 'Mod.Fast passes' -Result 'Passed' -Ms 50 -Level 'L1' -File 'C:\x\Fast.Tests.ps1' -Line 5
                New-FakeTest -Path 'Mod.Slow is slow' -Result 'Passed' -Ms 130000 -Level 'L2' -File 'C:\x\Slow.Tests.ps1' -Line 9
                New-FakeTest -Path 'Mod.Broken fails' -Result 'Failed' -Ms 10 -Level 'L1' -File 'C:\x\Broken.Tests.ps1' -Line 12 -Message 'Expected 1 but got 2'
            )
        }
    }

    It 'writes summary.md with counts, the failure (file:line + message), slowest, and over-limit timings' {
        $dir = Join-Path $TestDrive 'run-md'
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $dir; R = $script:result } {
            param($Dir, $R)
            Write-TestAutomationReport -Result $R -OutputFolder $Dir -Level 2
        }

        $md = Get-Content (Join-Path $dir 'summary.md') -Raw
        $md | Should -Match '\| 3 \| 2 \| 1 \| 0 \| 0 \|'      # counts row
        $md | Should -Match '## Failures \(1\)'
        $md | Should -Match 'Mod\.Broken fails'
        $md | Should -Match 'Broken\.Tests\.ps1:12'             # file:line
        $md | Should -Match 'Expected 1 but got 2'              # message
        $md | Should -Match '## Slowest tests'
        $md | Should -Match 'Mod\.Slow is slow'
        $md | Should -Match '\[L2 > 120000ms\]'                 # over-limit, report-only
    }

    It 'writes tests.csv with one row per test, slowest first' {
        $dir = Join-Path $TestDrive 'run-csv'
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $dir; R = $script:result } {
            param($Dir, $R)
            Write-TestAutomationReport -Result $R -OutputFolder $Dir -Level 2
        }

        $rows = Import-Csv (Join-Path $dir 'tests.csv')
        $rows | Should -HaveCount 3
        $rows[0].DurationMs | Should -Be '130000'              # slowest first
        $rows[0].Level | Should -Be 'L2'
        ($rows | Where-Object { $_.Result -eq 'Failed' }).ExpandedPath | Should -Be 'Mod.Broken fails'
    }

    It 'annotates the over-limit section as enforced when -TimingsEnforced' {
        $dir = Join-Path $TestDrive 'run-enforced'
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Dir = $dir; R = $script:result } {
            param($Dir, $R)
            Write-TestAutomationReport -Result $R -OutputFolder $Dir -Level 2 -TimingsEnforced
        }

        (Get-Content (Join-Path $dir 'summary.md') -Raw) | Should -Match 'Over-limit timings \(1\) \[enforced'
    }
}
