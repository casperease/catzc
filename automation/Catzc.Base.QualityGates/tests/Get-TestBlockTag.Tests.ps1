Describe 'Get-TestBlockTag' -Tag 'L0', 'logic' {
    BeforeAll {
        # A fake Pester test: own It-tags, an inner block, and an optional outer block. The test's .Block is
        # the inner block; explicit [string[]] params avoid array-of-array flattening.
        function New-FakeTest {
            param([string[]] $OwnTags = @(), [string[]] $InnerTags = @(), [string[]] $OuterTags)
            $root = [pscustomobject]@{ IsRoot = $true; Tag = @(); Parent = $null }
            $parent = if ($PSBoundParameters.ContainsKey('OuterTags')) {
                [pscustomobject]@{ IsRoot = $false; Tag = @($OuterTags); Parent = $root }
            }
            else {
                $root
            }
            $inner = [pscustomobject]@{ IsRoot = $false; Tag = @($InnerTags); Parent = $parent }
            [pscustomobject]@{ Tag = @($OwnTags); Block = $inner }
        }

        # @(...) re-arrayifies: InModuleScope (a pipeline boundary) unrolls a single-element array to a scalar.
        $script:tier = { param($Test) @(InModuleScope Catzc.Base.QualityGates -Parameters @{ T = $Test } { param($T) Get-TestBlockTag -Test $T -Valid 'L0', 'L1', 'L2', 'L3' }) }
        $script:category = { param($Test) @(InModuleScope Catzc.Base.QualityGates -Parameters @{ T = $Test } { param($T) Get-TestBlockTag -Test $T -Valid 'logic', 'integrity' }) }
    }

    It 'returns the nearest block tag (inner L2 overrides outer L1)' {
        $result = & $script:tier (New-FakeTest -OuterTags @('L1', 'logic') -InnerTags @('L2'))
        $result | Should -HaveCount 1
        $result[0] | Should -Be 'L2'
    }

    It 'falls through a block with no tag of this axis to the next ancestor' {
        # Inner block carries only a tier; category must come from the outer block.
        $result = & $script:category (New-FakeTest -OuterTags @('L1', 'logic') -InnerTags @('L2'))
        $result | Should -HaveCount 1
        $result[0] | Should -Be 'logic'
    }

    It 'returns empty when no block carries a tag of the axis' {
        (& $script:tier (New-FakeTest -InnerTags @('logic'))) | Should -HaveCount 0
    }

    It 'returns both tags when one block is ambiguous (two of the same axis)' {
        $result = & $script:tier (New-FakeTest -InnerTags @('L1', 'L2', 'logic'))
        $result | Should -HaveCount 2
        $result | Should -Contain 'L1'
        $result | Should -Contain 'L2'
    }

    It 'matches tags case-insensitively and returns canonical casing' {
        $result = & $script:tier (New-FakeTest -InnerTags @('l2'))
        $result | Should -HaveCount 1
        $result[0] | Should -Be 'L2'
    }

    It 'lets the test own It-tags win over the block chain' {
        $result = & $script:tier (New-FakeTest -OwnTags @('L0') -InnerTags @('L2'))
        $result[0] | Should -Be 'L0'
    }
}
