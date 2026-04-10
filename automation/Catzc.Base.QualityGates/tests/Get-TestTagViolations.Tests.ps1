Describe 'Get-TestTagViolations' -Tag 'L0', 'logic' {
    It 'flags tests missing or ambiguous on either axis, and passes fully-tagged tests' {
        InModuleScope Catzc.Base.QualityGates {
            $root = [pscustomobject]@{ IsRoot = $true; Tag = @(); Parent = $null }
            function New-FakeTest {
                param([string] $Name, [string[]] $Tags)
                [pscustomobject]@{
                    Tag          = @()
                    Block        = [pscustomobject]@{ IsRoot = $false; Tag = @($Tags); Parent = $root }
                    ExpandedName = $Name
                    ScriptBlock  = [pscustomobject]@{ File = 'fixture.Tests.ps1' }
                }
            }

            $discovered = [pscustomobject]@{
                Tests = @(
                    (New-FakeTest 'good' @('L1', 'logic'))
                    (New-FakeTest 'noTier' @('logic'))
                    (New-FakeTest 'noCategory' @('L2'))
                    (New-FakeTest 'ambiguousTier' @('L1', 'L2', 'logic'))
                )
            }
            Mock Invoke-Pester { $discovered }

            $violations = Get-TestTagViolations -TestPath 'unused-because-mocked'

            $violations | Should -HaveCount 3
            $violations.Test | Should -Not -Contain 'good'
            $violations.Test | Should -Contain 'noTier'
            $violations.Test | Should -Contain 'noCategory'
            $violations.Test | Should -Contain 'ambiguousTier'
            ($violations | Where-Object Test -EQ 'noTier').Reason | Should -BeLike '*tier resolves to 0*'
            ($violations | Where-Object Test -EQ 'ambiguousTier').Reason | Should -BeLike '*tier resolves to 2*L1,L2*'
        }
    }

    It 'returns an empty array when every test is fully tagged' {
        InModuleScope Catzc.Base.QualityGates {
            $root = [pscustomobject]@{ IsRoot = $true; Tag = @(); Parent = $null }
            $clean = [pscustomobject]@{
                Tests = @(
                    [pscustomobject]@{
                        Tag          = @()
                        Block        = [pscustomobject]@{ IsRoot = $false; Tag = @('L1', 'integrity'); Parent = $root }
                        ExpandedName = 'ok'
                        ScriptBlock  = [pscustomobject]@{ File = 'fixture.Tests.ps1' }
                    }
                )
            }
            Mock Invoke-Pester { $clean }

            $violations = Get-TestTagViolations -TestPath 'unused-because-mocked'
            $violations | Should -HaveCount 0
        }
    }
}
