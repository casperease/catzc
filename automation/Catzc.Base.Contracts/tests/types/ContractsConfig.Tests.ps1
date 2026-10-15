<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md
      source: automation/Catzc.Base.Contracts/types/ContractsConfig.cs
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-REPO-CONTRACT#{2,8}
---
#>

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

    Context 'target_roots' {
        It 'names no module when omitted, so every module takes the repository root' -Tag 'ADR-AUTO-DEFAULT#6', 'ADR-REPO-CONTRACT#2' {
            $config = [Catzc.Base.Contracts.ContractsConfig]::new(@{})
            $config.target_roots.Count | Should -Be 0
            [Catzc.Base.Contracts.ContractsConfig]::DefaultTargetRoot | Should -Be ''
            [Catzc.Base.Contracts.ContractsConfig]::ResolveTargetRoot($config.target_roots, 'Catzc.Widget') | Should -Be ''
            [Catzc.Base.Contracts.ContractsConfig]::ResolveTargetRoot($null, 'Catzc.Widget') | Should -Be ''
        }

        It 'resolves a declared module to its root, in ordinal module order' -Tag 'ADR-REPO-CONTRACT#2' {
            $config = [Catzc.Base.Contracts.ContractsConfig]::new(@{ target_roots = @{ 'Catzc.Widget' = '.widget'; 'Catzc.Gadget' = 'gadget/flows' } })
            @($config.target_roots.Keys) | Should -Be @('Catzc.Gadget', 'Catzc.Widget')
            [Catzc.Base.Contracts.ContractsConfig]::ResolveTargetRoot($config.target_roots, 'Catzc.Widget') | Should -Be '.widget'
            [Catzc.Base.Contracts.ContractsConfig]::ResolveTargetRoot($config.target_roots, 'Catzc.Gadget') | Should -Be 'gadget/flows'
            [Catzc.Base.Contracts.ContractsConfig]::ResolveTargetRoot($config.target_roots, 'Catzc.Sprocket') | Should -Be ''
        }

        It 'rejects the root <Root>' -Tag 'ADR-REPO-CONTRACT#2' -ForEach @(
            @{ Root = '../widget' }
            @{ Root = './widget' }
            @{ Root = '/widget' }
            @{ Root = 'widget/' }
            @{ Root = 'widget\gadget' }
            @{ Root = '' }
        ) {
            { [Catzc.Base.Contracts.ContractsConfig]::new(@{ target_roots = @{ 'Catzc.Widget' = $Root } }) } |
                Should -Throw "*target root '$([WildcardPattern]::Escape($Root))' of 'Catzc.Widget'*"
            { [Catzc.Base.Contracts.ContractsConfig]::ResolveTargetRoot(@{ 'Catzc.Widget' = $Root }, 'Catzc.Widget') } |
                Should -Throw "*target root '$([WildcardPattern]::Escape($Root))' of 'Catzc.Widget'*"
        }

        It 'rejects a key that is not a module name' -Tag 'ADR-REPO-CONTRACT#2' {
            { [Catzc.Base.Contracts.ContractsConfig]::new(@{ target_roots = @{ 'Catzc/Widget' = 'widget' } }) } |
                Should -Throw "*target_roots key 'Catzc/Widget' is not a module name*"
        }

        It 'rejects a target_roots that is not a map' -Tag 'ADR-REPO-CONTRACT#2' {
            { [Catzc.Base.Contracts.ContractsConfig]::new(@{ target_roots = 'widget' }) } | Should -Throw '*target_roots must be a map*'
        }
    }
}

Describe 'ContractsConfig (shipped contracts.yml)' -Tag 'L1', 'integrity' {
    It 'loads the shipped contracts.yml as a ContractsConfig on the built mode' -Tag 'ADR-REPO-CONTRACT#8' {
        $config = Get-Config -Config contracts
        $config | Should -BeOfType ([Catzc.Base.Contracts.ContractsConfig])
        $config.addressing | Should -BeIn ([Catzc.Base.Contracts.ContractsConfig]::BuiltAddressingModes)
    }

    It 'names a target root only for a module folder that exists' -Tag 'ADR-REPO-CONTRACT#2' {
        foreach ($module in (Get-Config -Config contracts).target_roots.Keys) {
            Join-Path (Get-RepositoryRoot) "automation/$module" | Should -Exist
        }
    }
}
