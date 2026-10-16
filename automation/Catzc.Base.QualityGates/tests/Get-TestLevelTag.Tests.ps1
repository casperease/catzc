<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Get-TestLevelTag.Tests.ps1
    folder: tests
    name: get-test-level-tag-tests
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

Describe 'Get-TestLevelTag' -Tag 'L0', 'logic' {
    BeforeAll {
        function New-FakeTest {
            param([string[]] $InnerTags = @(), [string[]] $OuterTags)
            $root = [pscustomobject]@{ IsRoot = $true; Tag = @(); Parent = $null }
            $parent = if ($PSBoundParameters.ContainsKey('OuterTags')) {
                [pscustomobject]@{ IsRoot = $false; Tag = @($OuterTags); Parent = $root }
            }
            else {
                $root
            }
            $inner = [pscustomobject]@{ IsRoot = $false; Tag = @($InnerTags); Parent = $parent }
            [pscustomobject]@{ Tag = @(); Block = $inner }
        }

        $script:level = { param($Test) InModuleScope Catzc.Base.QualityGates -Parameters @{ T = $Test } { param($T) Get-TestLevelTag -Test $T } }
    }

    It 'returns the single resolved tier (innermost wins)' {
        (& $script:level (New-FakeTest -OuterTags @('L1', 'logic') -InnerTags @('L2'))) | Should -Be 'L2'
    }

    It 'returns $null when no tier tag is present' {
        (& $script:level (New-FakeTest -InnerTags @('logic'))) | Should -BeNullOrEmpty
    }

    It 'returns $null when the tier is ambiguous (two tiers on one block)' {
        (& $script:level (New-FakeTest -InnerTags @('L1', 'L2'))) | Should -BeNullOrEmpty
    }
}
