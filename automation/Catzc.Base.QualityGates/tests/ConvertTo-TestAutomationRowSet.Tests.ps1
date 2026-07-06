Describe 'ConvertTo-TestAutomationRowSet' -Tag 'L0', 'logic' {
    BeforeAll {
        # Build a Pester-shaped test-result object without running Pester — just the members the reducer
        # reads (Result, Duration, ExpandedPath/Name, ErrorRecord, the Block tag chain, ScriptBlock file/line).
        function New-FakeTest {
            param($Path, $Result, $Ms, $Tags, $File, $Line, $Message, $Stack)
            $block = [pscustomobject]@{
                Tag    = @($Tags)
                IsRoot = $false
                Parent = [pscustomobject]@{ IsRoot = $true; Tag = @() }
            }
            $err = if ($Message) {
                [pscustomobject]@{
                    Exception        = [pscustomobject]@{ Message = $Message }
                    ScriptStackTrace = $Stack
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
            Tests = @(
                New-FakeTest -Path 'Mod.Fast passes' -Result 'Passed' -Ms 50 -Tags @('L0', 'logic') `
                    -File 'C:\x\Fast.Tests.ps1' -Line 5
                New-FakeTest -Path 'Mod.Broken fails' -Result 'Failed' -Ms 10 -Tags @('L1', 'logic') `
                    -File 'C:\x\Broken.Tests.ps1' -Line 12 -Message 'Expected 1 but got 2' `
                    -Stack 'at <ScriptBlock>, C:\x\Broken.Tests.ps1: line 12'
                New-FakeTest -Path 'Mod.Gated self-skips' -Result 'Skipped' -Ms 2 -Tags @('L2', 'integrity') `
                    -File 'C:\x\Gated.Tests.ps1' -Line 20 -Message 'is skipped, because tool_az_missing'
                New-FakeTest -Path 'Mod.Wide is out of scope' -Result 'NotRun' -Ms 0 -Tags @('L3', 'logic') `
                    -File 'C:\x\Wide.Tests.ps1' -Line 30
                New-FakeTest -Path 'Mod.Cited enforces a rule' -Result 'Passed' -Ms 3 `
                    -Tags @('L1', 'logic', 'ADR-FAKE#1', 'ADR-FAKE#2') -File 'C:\x\Cited.Tests.ps1' -Line 8
            )
        }

        $script:rows = @(InModuleScope Catzc.Base.QualityGates -Parameters @{ R = $script:result } {
                param($R)
                ConvertTo-TestAutomationRowSet -Result $R
            })
    }

    It 'emits one row per discovered test, in order, including Skipped and NotRun' {
        $script:rows | Should -HaveCount 5
        $script:rows.Result | Should -Be @('Passed', 'Failed', 'Skipped', 'NotRun', 'Passed')
        $script:rows[0].ExpandedPath | Should -Be 'Mod.Fast passes'
    }

    It 'resolves tier and category from the live block chain' {
        $script:rows[0].Level | Should -Be 'L0'
        $script:rows[0].Category | Should -Be 'logic'
        $script:rows[2].Level | Should -Be 'L2'
        $script:rows[2].Category | Should -Be 'integrity'
    }

    It 'joins the ADR provenance citations into Rules, and is empty when none are carried' {
        $script:rows[4].Rules | Should -Be 'ADR-FAKE#1;ADR-FAKE#2'
        $script:rows[0].Rules | Should -BeExactly ''
    }

    It 'carries duration, file, and line for every row' {
        $script:rows[0].DurationMs | Should -Be 50
        $script:rows[1].File | Should -Be 'C:\x\Broken.Tests.ps1'
        $script:rows[1].Line | Should -Be 12
    }

    It 'captures the failure message and stack only on failed rows' {
        $script:rows[1].ErrorMessage | Should -Be 'Expected 1 but got 2'
        $script:rows[1].ErrorStack | Should -Match 'Broken\.Tests\.ps1: line 12'
        $script:rows[0].ErrorMessage | Should -BeExactly ''
        $script:rows[2].ErrorMessage | Should -BeExactly ''
    }

    It 'resolves the -Because skip key only on skipped rows' {
        $script:rows[2].SkipReason | Should -Be 'tool_az_missing'
        $script:rows[0].SkipReason | Should -BeExactly ''
        $script:rows[3].SkipReason | Should -BeExactly ''
    }

    It 'round-trips through JSON without losing any field' {
        $json = ConvertTo-Json -InputObject $script:rows -Depth 4
        $back = @($json | ConvertFrom-Json)
        $back | Should -HaveCount 5
        $back[2].SkipReason | Should -Be 'tool_az_missing'
        $back[1].ErrorMessage | Should -Be 'Expected 1 but got 2'
        $back[3].Result | Should -Be 'NotRun'
        $back[4].Rules | Should -Be 'ADR-FAKE#1;ADR-FAKE#2'
    }
}
