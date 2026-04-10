# Get-TestExcludeTag is private (the tier/category -> ExcludeTag logic shared by Test-Automation and
# Test-InIsolation). Tested via InModuleScope.
Describe 'Get-TestExcludeTag' -Tag 'L0', 'logic' {
    It 'a Logic L0/L1 run excludes the higher tiers and integrity' {
        InModuleScope Catzc.Base.QualityGates {
            $tags = Get-TestExcludeTag -MinLevel 0 -MaxLevel 1 -Category Logic
            $tags | Should -Contain 'L2'
            $tags | Should -Contain 'L3'
            $tags | Should -Contain 'integrity'
            $tags | Should -Not -Contain 'L0'
            $tags | Should -Not -Contain 'logic'
        }
    }

    It 'an Integrity run excludes logic' {
        InModuleScope Catzc.Base.QualityGates {
            Get-TestExcludeTag -Category Integrity | Should -Contain 'logic'
        }
    }

    it 'a Both run through L3 excludes nothing' {
        InModuleScope Catzc.Base.QualityGates {
            @(Get-TestExcludeTag -MinLevel 0 -MaxLevel 3 -Category Both).Count | Should -Be 0
        }
    }

    It 'a MinLevel-2 run excludes the lower tiers' {
        InModuleScope Catzc.Base.QualityGates {
            $tags = Get-TestExcludeTag -MinLevel 2 -MaxLevel 2
            $tags | Should -Contain 'L0'
            $tags | Should -Contain 'L1'
            $tags | Should -Not -Contain 'L2'
        }
    }
}
