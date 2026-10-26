Describe 'AccostedConfig' -Tag 'L0', 'logic' {
    It 'takes the declared defaults for an empty or missing config' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER' {
        foreach ($raw in @(@{}, $null)) {
            $config = [Catzc.Base.Contracts.AccostedConfig]::new($raw)
            $config.harmless_verbs | Should -Be @('find', 'get', 'measure', 'test')
            $config.run_timeout | Should -Be 'run_list_seconds'
        }
    }

    It 'takes a configured verb list, sorted and without duplicates, and a configured timeout key' {
        $config = [Catzc.Base.Contracts.AccostedConfig]::new(@{ harmless_verbs = @('spin', 'get',
            'spin'); run_timeout = 'widget_run' })
        $config.harmless_verbs | Should -Be @('get', 'spin')
        $config.run_timeout | Should -Be 'widget_run'
    }

    It 'calls a command harmless exactly when its verb is on the list' {
        $config = [Catzc.Base.Contracts.AccostedConfig]::new(@{})
        $config.IsHarmlessVerb('get_widget') | Should -BeTrue
        $config.IsHarmlessVerb('test_gadget_set') | Should -BeTrue
        $config.IsHarmlessVerb('set_widget') | Should -BeFalse
        $config.IsHarmlessVerb('getter_widget') | Should -BeFalse
        $config.IsHarmlessVerb('') | Should -BeFalse
    }

    It 'rejects <Case>' -ForEach @(
        @{ Case = 'an unknown key'; Raw = @{ gadget = 1 }; Message = "*unknown key 'gadget'*" }
        @{ Case = 'a verb list that is a string'; Raw = @{ harmless_verbs = 'get' }; Message = '*must be a list*' }
        @{ Case = 'an empty verb list'; Raw = @{ harmless_verbs = @() }; Message = '*names no verb*' }
        @{ Case = 'a verb not in the normal form'; Raw = @{ harmless_verbs = @('Get') }; Message = "*harmless verb 'Get'*" }
        @{ Case = 'a timeout key not in the normal form'; Raw = @{ run_timeout = 'widget-run' }; Message = "*run_timeout 'widget-run'*" }
    ) {
        { [Catzc.Base.Contracts.AccostedConfig]::new($Raw) } | Should -Throw $Message
    }
}
