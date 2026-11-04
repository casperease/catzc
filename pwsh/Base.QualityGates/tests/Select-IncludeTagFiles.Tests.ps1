Describe 'Select-IncludeTagFiles' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-POSTBUILDTAG' {
    BeforeAll {
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
        function Select-Tagged {
            param([hashtable] $Arguments)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ A = $Arguments } {
                param($A)
                Select-IncludeTagFiles @A
            }
        }

        $script:widget = 'C:\repo\automation\Widget\tests\Get-Widget.Tests.ps1'
        $script:gadget = 'C:\repo\automation\Gadget\tests\Get-Gadget.Tests.ps1'
        $script:discovery = [pscustomobject]@{
            Tests = @(
                (New-FakeTest -File $script:widget -Name 'Widget.logic' -BlockTags @('L0', 'logic'))
                (New-FakeTest -File $script:gadget -Name 'Gadget.bundle' -BlockTags @('L2', 'integrity', 'sprocket'))
            )
        }
    }

    It 'keeps the files with a test carrying the tag, in the order given' {
        $result = Select-Tagged @{ TestFile = @($script:widget, $script:gadget); Discovery = $script:discovery; Tag = @('sprocket') }
        @($result) | Should -Be @($script:gadget)
    }

    It 'keeps nothing when no test carries the tag' {
        $result = Select-Tagged @{ TestFile = @($script:widget, $script:gadget); Discovery = $script:discovery; Tag = @('cog') }
        @($result).Count | Should -Be 0
    }

    It 'ignores a tagged test the exclude tags take out of the run' {
        $result = Select-Tagged @{
            TestFile = @($script:widget, $script:gadget); Discovery = $script:discovery; Tag = @('sprocket'); ExcludeTag = @('L2')
        }
        @($result).Count | Should -Be 0
    }

    It 'keeps only files the caller listed' {
        $result = Select-Tagged @{ TestFile = @($script:widget); Discovery = $script:discovery; Tag = @('sprocket') }
        @($result).Count | Should -Be 0
    }
}
