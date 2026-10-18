Describe 'Get-TestRunFile' -Tag 'L0', 'logic' {
    BeforeAll {
        function New-FakeTest {
            param([object] $Data, [object] $ScriptBlock = [pscustomobject]@{ File = 'C:\x\Widget.Tests.ps1' })
            [pscustomobject]@{
                Block       = [pscustomobject]@{ BlockContainer = [pscustomobject]@{ Data = $Data } }
                ScriptBlock = $ScriptBlock
            }
        }
        function Get-RunFile {
            param($Test)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Test = $Test } {
                param($Test)
                Get-TestRunFile -Test $Test
            }
        }
    }

    It 'names the test folder of a language bridge test' {
        Get-RunFile (New-FakeTest -Data @{ Language = 'python'; TestFolder = 'C:\x\python\tests\catzc-widget'; EntryScript = ''; Executable = '' }) |
            Should -Be 'C:\x\python\tests\catzc-widget'
    }

    It 'names the test file of a test whose container carries <Case>' -ForEach @(
        @{ Case = 'no data'; Data = $null }
        @{ Case = 'other data'; Data = @{ Gadget = 'C:\x\gadget' } }
    ) {
        Get-RunFile (New-FakeTest -Data $Data) | Should -Be 'C:\x\Widget.Tests.ps1'
    }

    It 'names the test file of a test with no container' {
        Get-RunFile ([pscustomobject]@{ ScriptBlock = [pscustomobject]@{ File = 'C:\x\Gadget.Tests.ps1' } }) | Should -Be 'C:\x\Gadget.Tests.ps1'
    }

    It 'returns empty for a test with neither a container folder nor a file' {
        Get-RunFile (New-FakeTest -Data $null -ScriptBlock $null) | Should -Be ''
    }
}
