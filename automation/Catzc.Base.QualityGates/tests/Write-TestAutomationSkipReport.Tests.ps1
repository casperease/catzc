[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Tests lift $global:__PesterRunning to verify writer output; that flag is the writers'' test-suppression interface, set by Test-Automation')]
param()

Describe 'Write-TestAutomationSkipReport' -Tag 'L0', 'logic' {
    # The writers' chokepoint returns early during a run ($global:__PesterRunning); lift it so the report's
    # information-stream output can be asserted (see console-output-matters / Write-InformationColored).
    BeforeAll {
        $global:__PesterRunning = $false

        # Rows are the plain per-test shape ConvertTo-TestAutomationRowSet produces — the report never sees
        # a live Pester object. SkipReason is pre-resolved by the reducer in the process that ran the test.
        function New-Row {
            param($Path, $Result, $Tier, $Category, $SkipReason = '')
            [pscustomobject]@{
                ExpandedPath = $Path
                ExpandedName = ($Path -split '\.')[-1]
                Result       = $Result
                DurationMs   = 1
                Level        = $Tier
                Category     = $Category
                File         = 'C:\x\Fake.Tests.ps1'
                Line         = 1
                ErrorMessage = ''
                ErrorStack   = ''
                SkipReason   = $SkipReason
            }
        }

        # Capture the information stream the report writes (flag already lifted above).
        function Get-ReportText {
            param($Rows, $MinLevel = 0, $MaxLevel = 1, $Category = 'Both')
            $text = InModuleScope Catzc.Base.QualityGates -Parameters @{ R = $Rows; Min = $MinLevel; Max = $MaxLevel; Cat = $Category } {
                param($R, $Min, $Max, $Cat)
                Write-TestAutomationSkipReport -Rows $R -MinLevel $Min -MaxLevel $Max -Category $Cat `
                    -InformationVariable iv -InformationAction SilentlyContinue 6>&1 | Out-Null
                ($iv | ForEach-Object { if ($_.MessageData -is [string]) {
                        $_.MessageData
                    }
                    else {
                        $_.MessageData.Message
                    } }) -join "`n"
            }
            # Strip ANSI so assertions match on text, not color codes.
            $text -replace "`e\[[0-9;]*m", ''
        }
    }
    AfterAll { $global:__PesterRunning = $true }

    It 'lists each skipped test with its resolved reason' {
        $rows = @(
            New-Row -Path 'Mod.az build compiles' -Result 'Skipped' -Tier 'L2' -Category 'logic' -SkipReason 'az not installed'
            New-Row -Path 'Mod.fast passes' -Result 'Passed' -Tier 'L1' -Category 'logic'
        )

        $text = Get-ReportText -Rows $rows -MaxLevel 2
        $text | Should -Match 'Skipped & not run'
        $text | Should -Match 'Skipped \(1\)'
        $text | Should -Match '\[az not installed\] Mod\.az build compiles'
    }

    It 'falls back to "no reason given" for a skip that carries no reason' {
        $rows = @(New-Row -Path 'Mod.bare skip' -Result 'Skipped' -Tier 'L1' -Category 'logic')

        (Get-ReportText -Rows $rows) | Should -Match '\[no reason given\] Mod\.bare skip'
    }

    It 'groups not-run tests by tier+category with the excluding scope' {
        $rows = @(
            New-Row -Path 'Mod.cloud thing' -Result 'NotRun' -Tier 'L3' -Category 'logic'
            New-Row -Path 'Mod.tool a' -Result 'NotRun' -Tier 'L2' -Category 'integrity'
            New-Row -Path 'Mod.tool b' -Result 'NotRun' -Tier 'L2' -Category 'integrity'
        )

        $text = Get-ReportText -Rows $rows -MaxLevel 1
        $text | Should -Match "Not run \(3\) — outside this run's scope \(-MaxLevel 1\)"
        $text | Should -Match 'L2 integrity: 2'
        $text | Should -Match 'L3 logic: 1'
    }

    It 'names -MinLevel and -Category in the scope when set' {
        $rows = @(New-Row -Path 'Mod.l1 integrity' -Result 'NotRun' -Tier 'L1' -Category 'integrity')

        $text = Get-ReportText -Rows $rows -MinLevel 2 -MaxLevel 2 -Category 'Logic'
        $text | Should -Match '-MaxLevel 2 -MinLevel 2 -Category Logic'
    }

    It 'stays silent when nothing was skipped or excluded' {
        $rows = @(New-Row -Path 'Mod.fast passes' -Result 'Passed' -Tier 'L1' -Category 'logic')

        Get-ReportText -Rows $rows -MaxLevel 1 | Should -BeNullOrEmpty
    }
}
