<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Select-TestRunFiles.Tests.ps1
    folder: tests
    name: select-test-run-files-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Select-TestRunFiles' -Tag 'L0', 'logic' {
    BeforeAll {
        # Fake discovery tests — the Pester test shape Get-TestBlockTag walks and ConvertTo-TestAutomationRowSet reads.
        $script:root = [pscustomobject]@{ IsRoot = $true; Tag = @(); Parent = $null }
        function New-FakeTest {
            param([string] $File, [string] $Name, [string[]] $BlockTags)
            [pscustomobject]@{
                Tag          = @()
                Block        = [pscustomobject]@{ IsRoot = $false; Tag = @($BlockTags); Parent = $script:root }
                ExpandedPath = $Name
                ExpandedName = $Name
                Result       = 'NotRun'
                Duration     = [timespan]::Zero
                ScriptBlock  = [pscustomobject]@{ File = $File; StartPosition = [pscustomobject]@{ StartLine = 1 } }
            }
        }
        function Select-Run {
            param([hashtable] $Arguments)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ A = $Arguments } {
                param($A)
                Select-TestRunFiles @A
            }
        }

        $script:widget = 'C:\repo\automation\Widget\tests\Get-Widget.Tests.ps1'
        $script:gadget = 'C:\repo\automation\Gadget\tests\Get-Gadget.Tests.ps1'
        $script:discovery = [pscustomobject]@{
            Tests = @(
                (New-FakeTest -File $script:widget -Name 'Widget.logic' -BlockTags @('L0', 'logic', 'ADR-TST-WIDGET#1'))
                (New-FakeTest -File $script:gadget -Name 'Gadget.real environment' -BlockTags @('L3', 'logic', 'source-only'))
            )
        }
    }

    BeforeEach {
        # The real shape: ONE array object (`, $array`), so a caller that wraps it in @() instead of casting it breaks.
        Mock Get-TestAutomationTestFiles -ModuleName Catzc.Base.QualityGates { , [string[]] @($script:widget, $script:gadget) }
        Mock Write-TestOptOutExclusion -ModuleName Catzc.Base.QualityGates { }
        $script:arguments = @{
            TestPath = @('C:\repo\automation\Widget\tests'); Discovery = $script:discovery
            RunDirectory = $TestDrive; EntryPoint = 'Test-Widget'
        }
    }

    It 'keeps every file and reports nothing out of scope when nothing narrows the run' {
        $result = Select-Run $script:arguments
        $result.Files | Should -Be @($script:widget, $script:gadget)
        @($result.OutOfScopeRows).Count | Should -Be 0
        @($result.OptOutExcludedTests).Count | Should -Be 0
    }

    It 'drops the files with no test in scope and returns their tests as NotRun rows' {
        $script:arguments.ExcludeTag = @('L0', 'L1', 'L2')
        $result = Select-Run $script:arguments
        $result.Files | Should -Be @($script:gadget)
        @($result.OutOfScopeRows.ExpandedPath) | Should -Be @('Widget.logic')
        @($result.OutOfScopeRows.Result) | Should -Be @('NotRun')
    }

    It 'throws when no test cites the -Rule' {
        $script:arguments.Rule = @('ADR-TST-GADGET#9')
        { Select-Run $script:arguments } | Should -Throw '*No test cites ADR-TST-GADGET#9*'
    }

    It 'adds the opt-out tag to the exclude tags and throws when it leaves nothing to run' {
        $script:arguments.ExcludeTag = @('L0', 'L1', 'L2')
        $script:arguments.OptOutTag = @('source-only')
        { Select-Run $script:arguments } | Should -Throw '*Every test in scope carries source-only*Test-Widget*'
    }

    It 'leaves a run the scope emptied vacuous, not an opt-out error' {
        $script:arguments.ExcludeTag = @('L0', 'L1', 'L2', 'L3')
        $script:arguments.OptOutTag = @('source-only')
        $result = Select-Run $script:arguments
        @($result.Files).Count | Should -Be 0
        @($result.OutOfScopeRows).Count | Should -Be 2
        $result.ExcludeTag | Should -Contain 'source-only'
    }
}
