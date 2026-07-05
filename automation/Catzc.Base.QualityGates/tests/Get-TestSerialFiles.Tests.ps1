Describe 'Get-TestSerialFiles' -Tag 'L0', 'logic' {
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

    It 'returns each file containing any serial-tagged test, distinct and sorted' {
        $discovered = [pscustomobject]@{
            Tests = @(
                (New-FakeTest -File 'C:\x\Zulu.Tests.ps1' -BlockTags @('L2', 'logic', 'serial'))
                (New-FakeTest -File 'C:\x\Zulu.Tests.ps1' -BlockTags @('L2', 'logic', 'serial'))
                (New-FakeTest -File 'C:\x\Alpha.Tests.ps1' -BlockTags @('L0', 'logic'))
                (New-FakeTest -File 'C:\x\Mike.Tests.ps1' -BlockTags @('L1', 'integrity', 'serial'))
            )
        }

        $files = InModuleScope Catzc.Base.QualityGates -Parameters @{ D = $discovered } {
            param($D)
            Get-TestSerialFiles -Discovery $D
        }

        $files | Should -Be @('C:\x\Mike.Tests.ps1', 'C:\x\Zulu.Tests.ps1')
    }

    It 'resolves a serial tag carried on the It itself' {
        $discovered = [pscustomobject]@{
            Tests = @(
                (New-FakeTest -File 'C:\x\ItLevel.Tests.ps1' -BlockTags @('L0', 'logic') -ItTags @('serial'))
            )
        }

        $files = InModuleScope Catzc.Base.QualityGates -Parameters @{ D = $discovered } {
            param($D)
            Get-TestSerialFiles -Discovery $D
        }

        $files | Should -Be @('C:\x\ItLevel.Tests.ps1')
    }

    It 'returns an empty array when nothing is tagged serial' {
        $discovered = [pscustomobject]@{
            Tests = @(
                (New-FakeTest -File 'C:\x\Alpha.Tests.ps1' -BlockTags @('L0', 'logic'))
            )
        }

        $files = InModuleScope Catzc.Base.QualityGates -Parameters @{ D = $discovered } {
            param($D)
            Get-TestSerialFiles -Discovery $D
        }

        $files | Should -HaveCount 0
    }
}
