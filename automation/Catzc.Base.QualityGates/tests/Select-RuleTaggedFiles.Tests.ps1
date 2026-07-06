Describe 'Select-RuleTaggedFiles' -Tag 'L0', 'logic', 'ADR-TEST#27' {
    BeforeAll {
        # Fake discovery tests keyed by file, each with a block-chain the resolver walks. Built here (plain
        # data) and passed into module scope.
        function New-FakeTest {
            param([string] $File, [string[]] $Tags)
            $root = [pscustomobject]@{ IsRoot = $true; Tag = @(); Parent = $null }
            [pscustomobject]@{
                Tag         = @()
                Block       = [pscustomobject]@{ IsRoot = $false; Tag = @($Tags); Parent = $root }
                ScriptBlock = [pscustomobject]@{ File = $File }
            }
        }
        $script:discovery = [pscustomobject]@{
            Tests = @(
                New-FakeTest 'C:\r\a.Tests.ps1' @('L0', 'logic', 'ADR-FAKE#1')
                New-FakeTest 'C:\r\b.Tests.ps1' @('L1', 'logic')
                New-FakeTest 'C:\r\c.Tests.ps1' @('L1', 'logic', 'ADR-FAKE#2')
            )
        }
        $script:select = {
            param($Files, $Rule)
            InModuleScope Catzc.Base.QualityGates -Parameters @{ F = $Files; D = $script:discovery; R = $Rule } {
                param($F, $D, $R) Select-RuleTaggedFiles -TestFile $F -Discovery $D -Rule $R
            }
        }
    }

    It 'keeps only the files whose tests cite one of the rules, in input order' {
        $result = & $script:select @('C:\r\a.Tests.ps1', 'C:\r\b.Tests.ps1', 'C:\r\c.Tests.ps1') @('ADR-FAKE#1', 'ADR-FAKE#2')
        @($result) | Should -Be @('C:\r\a.Tests.ps1', 'C:\r\c.Tests.ps1')
    }

    It 'returns empty when no test cites the rule' {
        @(& $script:select @('C:\r\a.Tests.ps1', 'C:\r\b.Tests.ps1', 'C:\r\c.Tests.ps1') @('ADR-FAKE#7')) | Should -HaveCount 0
    }
}
