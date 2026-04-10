[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Tests lift $global:__PesterRunning to verify writer output; that flag is the writers'' test-suppression interface, set by Test-Automation')]
param()

Describe 'Write-TestAutomationSkipReport' -Tag 'L0', 'logic' {
    # The writers' chokepoint returns early during a run ($global:__PesterRunning); lift it so the report's
    # information-stream output can be asserted (see console-output-matters / Write-InformationColored).
    BeforeAll {
        $global:__PesterRunning = $false

        # A Pester test-result object: .Result, .ExpandedPath, .ErrorRecord (skip reason), and a .Block tag
        # chain carrying both axes (tier + category) the way a Describe -Tag does. $SkipMessage seeds the
        # ErrorRecord for a skipped test.
        function New-FakeTest {
            param($Path, $Result, $Tier, $Category, $SkipMessage)
            $records = if ($SkipMessage) {
                @([pscustomobject]@{ Exception = [pscustomobject]@{ Message = $SkipMessage } })
            }
            else {
                @()
            }
            [pscustomobject]@{
                Result       = $Result
                ExpandedPath = $Path
                ErrorRecord  = $records
                Tag          = @()
                Block        = [pscustomobject]@{
                    Tag    = @($Tier, $Category)
                    IsRoot = $false
                    Parent = [pscustomobject]@{ IsRoot = $true; Tag = @() }
                }
            }
        }

        # Capture the information stream the report writes (flag already lifted above).
        function Get-ReportText {
            param($Result, $MinLevel = 0, $MaxLevel = 1, $Category = 'Both')
            $text = InModuleScope Catzc.Base.QualityGates -Parameters @{ R = $Result; Min = $MinLevel; Max = $MaxLevel; Cat = $Category } {
                param($R, $Min, $Max, $Cat)
                Write-TestAutomationSkipReport -Result $R -MinLevel $Min -MaxLevel $Max -Category $Cat `
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

    It 'lists each skipped test with its -Because reason' {
        $result = [pscustomobject]@{
            Tests = @(
                New-FakeTest -Path 'Mod.az build compiles' -Result 'Skipped' -Tier 'L2' -Category 'logic' -SkipMessage 'is skipped, because az not installed'
                New-FakeTest -Path 'Mod.fast passes' -Result 'Passed' -Tier 'L1' -Category 'logic'
            )
        }

        $text = Get-ReportText -Result $result -MaxLevel 2
        $text | Should -Match 'Skipped & not run'
        $text | Should -Match 'Skipped \(1\)'
        $text | Should -Match '\[az not installed\] Mod\.az build compiles'
    }

    It 'groups not-run tests by tier+category with the excluding scope' {
        $result = [pscustomobject]@{
            Tests = @(
                New-FakeTest -Path 'Mod.cloud thing' -Result 'NotRun' -Tier 'L3' -Category 'logic'
                New-FakeTest -Path 'Mod.tool a' -Result 'NotRun' -Tier 'L2' -Category 'integrity'
                New-FakeTest -Path 'Mod.tool b' -Result 'NotRun' -Tier 'L2' -Category 'integrity'
            )
        }

        $text = Get-ReportText -Result $result -MaxLevel 1
        $text | Should -Match "Not run \(3\) — outside this run's scope \(-MaxLevel 1\)"
        $text | Should -Match 'L2 integrity: 2'
        $text | Should -Match 'L3 logic: 1'
    }

    It 'names -MinLevel and -Category in the scope when set' {
        $result = [pscustomobject]@{
            Tests = @(
                New-FakeTest -Path 'Mod.l1 integrity' -Result 'NotRun' -Tier 'L1' -Category 'integrity'
            )
        }

        $text = Get-ReportText -Result $result -MinLevel 2 -MaxLevel 2 -Category 'Logic'
        $text | Should -Match '-MaxLevel 2 -MinLevel 2 -Category Logic'
    }

    It 'stays silent when nothing was skipped or excluded' {
        $result = [pscustomobject]@{
            Tests = @(
                New-FakeTest -Path 'Mod.fast passes' -Result 'Passed' -Tier 'L1' -Category 'logic'
            )
        }

        Get-ReportText -Result $result -MaxLevel 1 | Should -BeNullOrEmpty
    }
}
