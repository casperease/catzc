Describe 'TestTiers' -Tag 'L0', 'logic' {
    It 'lists the tiers lowest first, L0 to L4' {
        [Catzc.Base.Timeouts.TestTiers]::Names | Should -Be @('L0', 'L1', 'L2', 'L3', 'L4')
    }

    It 'names the highest tier, and a default top tier below it (L4 is opt-in)' {
        [Catzc.Base.Timeouts.TestTiers]::Highest | Should -Be ([Catzc.Base.Timeouts.TestTiers]::Names.Count - 1)
        [Catzc.Base.Timeouts.TestTiers]::DefaultTop | Should -Be 3
    }
}
