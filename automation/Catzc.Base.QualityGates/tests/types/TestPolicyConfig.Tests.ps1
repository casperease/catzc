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
