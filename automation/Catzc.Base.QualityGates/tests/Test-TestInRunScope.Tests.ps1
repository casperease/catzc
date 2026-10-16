<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Test-TestInRunScope.Tests.ps1
    folder: tests
    name: test-test-in-run-scope-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Test-TestInRunScope' -Tag 'L0', 'logic' {
    BeforeAll {
        # Fake discovery tests — the Pester test shape Get-TestBlockTag walks (own It-tags, then the block chain).
        $script:root = [pscustomobject]@{ IsRoot = $true; Tag = @(); Parent = $null }
        function New-FakeTest {
            param([string[]] $BlockTags, [string[]] $ItTags = @())
            [pscustomobject]@{
                Tag   = @($ItTags)
                Block = [pscustomobject]@{ IsRoot = $false; Tag = @($BlockTags); Parent = $script:root }
            }
        }
        function Test-Scope {
            param($Test, [string[]] $ExcludeTag)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ T = $Test; X = $ExcludeTag } {
                param($T, $X)
                Test-TestInRunScope -Test $T -ExcludeTag $X
            }
        }
    }

    It 'is in scope when neither its tier nor its category is excluded' {
        Test-Scope (New-FakeTest @('L2', 'logic')) @('L0', 'L1', 'integrity') | Should -BeTrue
    }

    It 'is out of scope when its tier is excluded' {
        Test-Scope (New-FakeTest @('L0', 'logic')) @('L0') | Should -BeFalse
    }

    It 'is out of scope when its category is excluded' {
        Test-Scope (New-FakeTest @('L2', 'integrity')) @('integrity') | Should -BeFalse
    }

    It 'resolves the nearest block: an It tag overrides the block' {
        Test-Scope (New-FakeTest @('L0', 'logic') -ItTags @('L3')) @('L0', 'L1', 'L2') | Should -BeTrue
    }

    It 'is in scope when the run excludes nothing' {
        Test-Scope (New-FakeTest @('L0', 'logic')) @() | Should -BeTrue
    }
}
