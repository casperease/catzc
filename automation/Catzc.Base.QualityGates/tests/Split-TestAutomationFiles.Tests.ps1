<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Split-TestAutomationFiles.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      source: automation/Catzc.Base.QualityGates/private/Split-TestAutomationFiles.ps1
    adrs:
      - ADR-AUTO-TEST#26
---
#>

Describe 'Split-TestAutomationFiles' -Tag 'L0', 'logic' {
    BeforeAll {
        # Fake discovery objects — the same Pester test shape Get-TestBlockTag walks.
        $script:root = [pscustomobject]@{ IsRoot = $true; Tag = @(); Parent = $null }
        function New-FakeTest {
            param([string] $File, [string[]] $BlockTags, [string[]] $ItTags = @())
            [pscustomobject]@{
                Tag          = @($ItTags)
                Block        = [pscustomobject]@{ IsRoot = $false; Tag = @($BlockTags); Parent = $script:root }
                ExpandedName = 'x'
                ScriptBlock  = [pscustomobject]@{ File = $File }
            }
        }
    }

    It 'splits files into parallel, greedy, and serial by their tests'' phase tags' -Tag 'ADR-AUTO-TEST#26' {
        $discovered = [pscustomobject]@{
            Tests = @(
                (New-FakeTest -File 'C:\x\Zulu.Tests.ps1' -BlockTags @('L2', 'logic', 'serial'))
                (New-FakeTest -File 'C:\x\Alpha.Tests.ps1' -BlockTags @('L0', 'logic'))
                (New-FakeTest -File 'C:\x\Mike.Tests.ps1' -BlockTags @('L2', 'integrity', 'greedy'))
            )
        }

        $split = InModuleScope Catzc.Base.QualityGates -Parameters @{ D = $discovered } {
            param($D)
            Split-TestAutomationFiles -Discovery $D -TestFiles @('C:\x\Zulu.Tests.ps1', 'C:\x\Alpha.Tests.ps1', 'C:\x\Mike.Tests.ps1')
        }

        $split.Parallel | Should -Be @('C:\x\Alpha.Tests.ps1')
        $split.Greedy | Should -Be @('C:\x\Mike.Tests.ps1')
        $split.Serial | Should -Be @('C:\x\Zulu.Tests.ps1')
    }

    It 'one tagged test moves its whole file, and serial wins over greedy' {
        $discovered = [pscustomobject]@{
            Tests = @(
                (New-FakeTest -File 'C:\x\Both.Tests.ps1' -BlockTags @('L2', 'logic', 'greedy'))
                (New-FakeTest -File 'C:\x\Both.Tests.ps1' -BlockTags @('L2', 'logic', 'serial'))
                (New-FakeTest -File 'C:\x\ItLevel.Tests.ps1' -BlockTags @('L0', 'logic') -ItTags @('greedy'))
                (New-FakeTest -File 'C:\x\ItLevel.Tests.ps1' -BlockTags @('L0', 'logic'))
            )
        }

        $split = InModuleScope Catzc.Base.QualityGates -Parameters @{ D = $discovered } {
            param($D)
            Split-TestAutomationFiles -Discovery $D -TestFiles @('C:\x\Both.Tests.ps1', 'C:\x\ItLevel.Tests.ps1')
        }

        $split.Serial | Should -Be @('C:\x\Both.Tests.ps1')
        $split.Greedy | Should -Be @('C:\x\ItLevel.Tests.ps1')
        $split.Parallel | Should -HaveCount 0
    }

    It 'leaves the tier out of the phase: an L3 system test runs in the parallel phase unless it carries a phase tag' {
        $discovered = [pscustomobject]@{
            Tests = @(
                (New-FakeTest -File 'C:\x\Widget.Tests.ps1' -BlockTags @('L3', 'logic'))
                (New-FakeTest -File 'C:\x\Gadget.Tests.ps1' -BlockTags @('L3', 'logic', 'serial'))
            )
        }

        $split = InModuleScope Catzc.Base.QualityGates -Parameters @{ D = $discovered } {
            param($D)
            Split-TestAutomationFiles -Discovery $D -TestFiles @('C:\x\Widget.Tests.ps1', 'C:\x\Gadget.Tests.ps1')
        }

        $split.Parallel | Should -Be @('C:\x\Widget.Tests.ps1')
        $split.Serial | Should -Be @('C:\x\Gadget.Tests.ps1')
        $split.PSObject.Properties.Name | Should -Be @('Parallel', 'Greedy', 'Serial')
    }

    It 'returns everything parallel when nothing carries a phase tag' {
        $discovered = [pscustomobject]@{
            Tests = @(
                (New-FakeTest -File 'C:\x\Alpha.Tests.ps1' -BlockTags @('L0', 'logic'))
            )
        }

        $split = InModuleScope Catzc.Base.QualityGates -Parameters @{ D = $discovered } {
            param($D)
            Split-TestAutomationFiles -Discovery $D -TestFiles @('C:\x\Alpha.Tests.ps1')
        }

        $split.Parallel | Should -Be @('C:\x\Alpha.Tests.ps1')
        $split.Greedy | Should -HaveCount 0
        $split.Serial | Should -HaveCount 0
    }

    It 'schedules a language bridge test by its test folder, not by the bridge file' {
        # The bridge's tests come from one shared file; the container data names the test folder they run.
        $goTest = New-FakeTest -File 'C:\x\Language.Bridge.ps1' -BlockTags @('L2', 'greedy')
        $goTest.Block | Add-Member -NotePropertyName BlockContainer -NotePropertyValue ([pscustomobject]@{
                Data = @{ Language = 'go'; TestFolder = 'C:\x\go\tests\catzc-widget'; EntryScript = ''; Executable = '' }
            })
        $discovered = [pscustomobject]@{
            Tests = @($goTest, (New-FakeTest -File 'C:\x\Alpha.Tests.ps1' -BlockTags @('L0', 'logic')))
        }

        $split = InModuleScope Catzc.Base.QualityGates -Parameters @{ D = $discovered } {
            param($D)
            Split-TestAutomationFiles -Discovery $D -TestFiles @('C:\x\go\tests\catzc-widget', 'C:\x\Alpha.Tests.ps1')
        }

        $split.Greedy | Should -Be @('C:\x\go\tests\catzc-widget')
        $split.Parallel | Should -Be @('C:\x\Alpha.Tests.ps1')
    }
}
