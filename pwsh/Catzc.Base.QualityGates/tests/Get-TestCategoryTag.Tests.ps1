Describe 'Get-TestCategoryTag' -Tag 'L0', 'logic' {
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

        $script:category = { param($Test) InModuleScope Catzc.Base.QualityGates -Parameters @{ T = $Test } { param($T) Get-TestCategoryTag -Test $T } }
    }

    It 'returns the single resolved category (innermost wins)' {
        (& $script:category (New-FakeTest -OuterTags @('logic') -InnerTags @('L2', 'integrity'))) | Should -Be 'integrity'
    }

    It 'returns $null when no category tag is present' {
        (& $script:category (New-FakeTest -InnerTags @('L1'))) | Should -BeNullOrEmpty
    }

    It 'returns $null when the category is ambiguous (both on one block)' {
        (& $script:category (New-FakeTest -InnerTags @('logic', 'integrity'))) | Should -BeNullOrEmpty
    }
}
