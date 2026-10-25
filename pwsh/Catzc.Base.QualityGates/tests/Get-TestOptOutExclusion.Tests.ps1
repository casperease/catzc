Describe 'Get-TestOptOutExclusion' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-SOURCEONLYTAG' {
    BeforeAll {
        # Fake discovery objects — the same Pester test shape Get-TestBlockTag walks.
        $script:root = [pscustomobject]@{ IsRoot = $true; Tag = @(); Parent = $null }
        function New-FakeTest {
            param([string] $File, [string] $Name, [string[]] $BlockTags, [string[]] $ItTags = @())
            [pscustomobject]@{
                Tag          = @($ItTags)
                Block        = [pscustomobject]@{ IsRoot = $false; Tag = @($BlockTags); Parent = $script:root }
                ExpandedPath = $Name
                ScriptBlock  = [pscustomobject]@{ File = $File }
            }
        }

        function Invoke-Exclusion {
            param($Tests, [string[]] $ExcludeTag = @(), [string[]] $TestFiles)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ D = [pscustomobject]@{ Tests = @($Tests) }; X = $ExcludeTag; F = $TestFiles } {
                param($D, $X, $F)
                Get-TestOptOutExclusion -Discovery $D -Tag 'source-only' -ExcludeTag $X -TestFiles $F
            }
        }
    }

    It 'lists every in-scope test carrying the tag, resolved along the block chain' {
        $tests = @(
            (New-FakeTest -File 'C:\x\Widget.Tests.ps1' -Name 'Widget.reads files' -BlockTags @('L0', 'integrity', 'source-only'))
            (New-FakeTest -File 'C:\x\Widget.Tests.ps1' -Name 'Widget.runs code' -BlockTags @('L0', 'logic'))
            (New-FakeTest -File 'C:\x\Gadget.Tests.ps1' -Name 'Gadget.it-level' -BlockTags @('L1', 'logic') -ItTags @('source-only'))
        )
        $result = Invoke-Exclusion -Tests $tests -TestFiles @('C:\x\Widget.Tests.ps1', 'C:\x\Gadget.Tests.ps1')

        @($result.Tests.ExpandedPath) | Should -Be @('Widget.reads files', 'Gadget.it-level')
        $result.Tests[0].Level | Should -Be 'L0'
        $result.Tests[0].Category | Should -Be 'integrity'
    }

    It 'returns only files whose every in-scope test is excluded as fully excluded' {
        $tests = @(
            (New-FakeTest -File 'C:\x\Widget.Tests.ps1' -Name 'Widget.a' -BlockTags @('L0', 'integrity', 'source-only'))
            (New-FakeTest -File 'C:\x\Widget.Tests.ps1' -Name 'Widget.b' -BlockTags @('L0', 'logic'))
            (New-FakeTest -File 'C:\x\Gadget.Tests.ps1' -Name 'Gadget.a' -BlockTags @('L0', 'integrity', 'source-only'))
        )
        $result = Invoke-Exclusion -Tests $tests -TestFiles @('C:\x\Widget.Tests.ps1', 'C:\x\Gadget.Tests.ps1')

        @($result.FullyExcludedFiles) | Should -Be @('C:\x\Gadget.Tests.ps1')
        @($result.RemainingFiles) | Should -Be @('C:\x\Widget.Tests.ps1')
    }

    It 'ignores tests the run filters out by tier or category anyway' {
        $tests = @(
            (New-FakeTest -File 'C:\x\Widget.Tests.ps1' -Name 'Widget.l3' -BlockTags @('L3', 'integrity', 'source-only'))
            (New-FakeTest -File 'C:\x\Widget.Tests.ps1' -Name 'Widget.integrity' -BlockTags @('L0', 'integrity', 'source-only'))
            (New-FakeTest -File 'C:\x\Widget.Tests.ps1' -Name 'Widget.logic' -BlockTags @('L0', 'logic'))
        )
        $result = Invoke-Exclusion -Tests $tests -ExcludeTag @('L3', 'integrity') -TestFiles @('C:\x\Widget.Tests.ps1')

        $result.Tests | Should -HaveCount 0
        $result.FullyExcludedFiles | Should -HaveCount 0
    }

    It 'ignores tests outside the run''s files' {
        $tests = @(
            (New-FakeTest -File 'C:\x\Gadget.Tests.ps1' -Name 'Gadget.a' -BlockTags @('L0', 'integrity', 'source-only'))
        )
        $result = Invoke-Exclusion -Tests $tests -TestFiles @('C:\x\Widget.Tests.ps1')

        $result.Tests | Should -HaveCount 0
    }
}
