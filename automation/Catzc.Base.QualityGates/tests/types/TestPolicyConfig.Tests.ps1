Describe 'TestPolicyConfig' -Tag 'L0', 'logic' {
    It 'defaults every environment to read-only' {
        $config = [Catzc.Base.QualityGates.TestPolicyConfig]::new([ordered]@{})
        $config.MutationFor('widget') | Should -Be 'read-only'
        $config.Allows('widget', 'read-only') | Should -BeTrue
        $config.Allows('widget', 'synthetic') | Should -BeFalse
    }

    It 'lets a listed environment take synthetic transactions, which include read-only probes' {
        $config = [Catzc.Base.QualityGates.TestPolicyConfig]::new([ordered]@{ l4_mutation = @{ gadget = 'synthetic' } })
        $config.MutationFor('Gadget') | Should -Be 'synthetic'
        $config.Allows('gadget', 'synthetic') | Should -BeTrue
        $config.Allows('gadget', 'read-only') | Should -BeTrue
        $config.Allows('widget', 'synthetic') | Should -BeFalse
    }

    It 'runs greedy files in pairs unless the config says otherwise' {
        [Catzc.Base.QualityGates.TestPolicyConfig]::new([ordered]@{}).greedy_group_size | Should -Be 2
        [Catzc.Base.QualityGates.TestPolicyConfig]::new([ordered]@{ greedy_group_size = 1 }).greedy_group_size | Should -Be 1
        [Catzc.Base.QualityGates.TestPolicyConfig]::new([ordered]@{ greedy_group_size = 3 }).greedy_group_size | Should -Be 3
    }

    It 'throws on a greedy_group_size of <value>' -ForEach @(
        @{ value = 0 }
        @{ value = 65 }
        @{ value = 'pairs' }
    ) {
        { [Catzc.Base.QualityGates.TestPolicyConfig]::new(@{ greedy_group_size = $value }) } | Should -Throw '*greedy_group_size must be a whole number from 1 to 64*'
    }

    It 'throws on <case>' -ForEach @(
        @{ case = 'an unknown key'; data = @{ l5_mutation = @{} }; expected = "*unknown key 'l5_mutation'*" }
        @{ case = 'a mode that is not one'; data = @{ l4_mutation = @{ widget = 'destructive' } }; expected = "*l4_mutation.widget 'destructive' is not one of: read-only, synthetic*" }
        @{ case = 'a list instead of a map'; data = @{ l4_mutation = @('widget') }; expected = '*l4_mutation must be a map*' }
    ) {
        { [Catzc.Base.QualityGates.TestPolicyConfig]::new($data) } | Should -Throw $expected
    }

    It 'rejects a mode it does not know when asked' {
        $config = [Catzc.Base.QualityGates.TestPolicyConfig]::new([ordered]@{})
        { $config.Allows('widget', 'destructive') } | Should -Throw "*'destructive' is not a mutation mode*"
    }
}
