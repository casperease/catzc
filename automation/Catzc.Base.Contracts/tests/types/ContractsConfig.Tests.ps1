# ContractsConfig maps contracts.yml and is the one declaration of its sensible defaults
# ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)): an omitted key behaves exactly
# like the default, a declared but unbuilt addressing mode is a valid value, and anything else fails at construction.
Describe 'ContractsConfig' -Tag 'L0', 'logic' {
    It 'takes full-path for an omitted addressing' -Tag 'ADR-AUTO-DEFAULT#6' {
        [Catzc.Base.Contracts.ContractsConfig]::new(@{}).addressing | Should -Be 'full-path'
        [Catzc.Base.Contracts.ContractsConfig]::new($null).addressing | Should -Be 'full-path'
    }

    It 'accepts every declared addressing mode, built or not' -Tag 'ADR-REPO-CONTRACT#8' {
        foreach ($mode in [Catzc.Base.Contracts.ContractsConfig]::AddressingModes) {
            [Catzc.Base.Contracts.ContractsConfig]::new(@{ addressing = $mode }).addressing | Should -Be $mode
        }
    }

    It 'builds only full-path' -Tag 'ADR-REPO-CONTRACT#8' {
        [Catzc.Base.Contracts.ContractsConfig]::BuiltAddressingModes | Should -Be @('full-path')
    }

    It 'rejects an undeclared addressing mode, naming the declared ones' -Tag 'ADR-REPO-CONTRACT#8' {
        { [Catzc.Base.Contracts.ContractsConfig]::new(@{ addressing = 'widget' }) } | Should -Throw '*full-path, manifest-glob, per-folder*'
    }

    It 'rejects an unknown key' -Tag 'ADR-REPO-CONTRACT#8' {
        { [Catzc.Base.Contracts.ContractsConfig]::new(@{ gadget = 1 }) } | Should -Throw "*unknown key 'gadget'*"
    }
}

Describe 'ContractsConfig (shipped contracts.yml)' -Tag 'L1', 'integrity' {
    It 'loads the shipped contracts.yml as a ContractsConfig on the built mode' -Tag 'ADR-REPO-CONTRACT#8' {
        $config = Get-Config -Config contracts
        $config | Should -BeOfType ([Catzc.Base.Contracts.ContractsConfig])
        $config.addressing | Should -BeIn ([Catzc.Base.Contracts.ContractsConfig]::BuiltAddressingModes)
    }
}
