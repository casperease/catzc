Describe 'Get-TestRuleTags' -Tag 'L0', 'logic', 'ADR-TEST#27' {
    BeforeAll {
        # A fake Pester test: own It-tags, an inner block, and an optional outer block (the same shape
        # Get-TestBlockTag.Tests.ps1 uses). The test's .Block is the inner block.
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
        $script:rules = { param($Test) @(InModuleScope Catzc.Base.QualityGates -Parameters @{ T = $Test } { param($T) Get-TestRuleTags -Test $T }) }
    }

    It 'unions citations across own tags and every ancestor block' {
        $result = & $script:rules (New-FakeTest -OwnTags @('L0', 'logic', 'ADR-FAKE#1') -InnerTags @('ADR-FAKE#8') -OuterTags @('ADR-FAKE#2'))
        $result | Should -Be @('ADR-FAKE#1', 'ADR-FAKE#2', 'ADR-FAKE#8')
    }

    It 'de-duplicates a citation carried at more than one level' {
        $result = & $script:rules (New-FakeTest -OwnTags @('ADR-FAKE#1') -InnerTags @('ADR-FAKE#1'))
        $result | Should -Be @('ADR-FAKE#1')
    }

    It 'ignores the tier, category and serial tags' {
        (& $script:rules (New-FakeTest -InnerTags @('L2', 'integrity', 'serial'))) | Should -HaveCount 0
    }

    It 'ignores a malformed citation (registry colon form, missing number, wrong case)' {
        $result = & $script:rules (New-FakeTest -InnerTags @('ADR-ERROR:3', 'ADR-ERROR', 'adr-error#3'))
        $result | Should -HaveCount 0
    }

    It 'returns empty when the test carries no citation' {
        (& $script:rules (New-FakeTest -OwnTags @('L0', 'logic'))) | Should -HaveCount 0
    }
}
