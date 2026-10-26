Describe 'CapabilitiesConfig' -Tag 'L0', 'logic', 'ADR-REPO-AGENTS-CAPABILITYREGISTERED' {
    BeforeAll {
        $script:widget = [ordered]@{ name = 'widget-spin'; supported_by = @('ADR-WIDGET-ONE-TURN'); checks = @('Test-Widget') }
        $script:gadget = [ordered]@{ name = 'gadget-turn-fast'; supported_by = @('ADR-WIDGET-ONE-SPIN'); checks = @() }
    }

    It 'constructs and exposes the capabilities in file order' {
        $config = [Catzc.Base.Docs.CapabilitiesConfig]::new([ordered]@{ capabilities = @($widget, $gadget) })
        $config.capabilities.name | Should -Be @('widget-spin', 'gadget-turn-fast')
        $config.capabilities[0] | Should -BeOfType ([Catzc.Base.Docs.CapabilityEntry])
        $config.capabilities[0].checks | Should -Be @('Test-Widget')
    }

    It 'defaults invoked_by to robot, takes user and brief, and rejects any other invoker' -Tag 'ADR-REPO-AGENTS-USERSKILL', 'ADR-REPO-AGENTS-NOORPHANNOGHOST' {
        $user = [ordered]@{ name = 'gadget-turn'; supported_by = @('ADR-WIDGET-ONE-SPIN'); checks = @(); invoked_by = 'user' }
        $brief = [ordered]@{ name = 'gadget-spin'; supported_by = @('ADR-WIDGET-ONE-SPIN'); checks = @(); invoked_by = 'brief' }
        $config = [Catzc.Base.Docs.CapabilitiesConfig]::new([ordered]@{ capabilities = @($widget, $user, $brief) })
        $config.capabilities.invoked_by | Should -Be @('robot', 'user', 'brief')
        $gizmo = [ordered]@{ name = 'gadget-turn'; supported_by = @('ADR-WIDGET-ONE-SPIN'); checks = @(); invoked_by = 'gizmo' }
        { [Catzc.Base.Docs.CapabilitiesConfig]::new([ordered]@{ capabilities = @($gizmo) }) } |
            Should -Throw '*capabilities`[0`]: invoked_by must be one of: robot, user, brief*'
    }

    It 'defaults read_only to false, takes a boolean, and rejects anything else' -Tag 'ADR-REPO-AGENTS-CAPABILITYFILE' {
        $reader = [ordered]@{ name = 'gadget-turn'; supported_by = @('ADR-WIDGET-ONE-SPIN'); checks = @(); read_only = $true }
        $config = [Catzc.Base.Docs.CapabilitiesConfig]::new([ordered]@{ capabilities = @($widget, $reader) })
        $config.capabilities.read_only | Should -Be @($false, $true)
        $gizmo = [ordered]@{ name = 'gadget-turn'; supported_by = @('ADR-WIDGET-ONE-SPIN'); checks = @(); read_only = 'yes' }
        { [Catzc.Base.Docs.CapabilitiesConfig]::new([ordered]@{ capabilities = @($gizmo) }) } |
            Should -Throw '*capabilities`[0`]: read_only must be true or false*'
    }

    It 'requires capabilities and rejects an unknown key' {
        $thrown = { [Catzc.Base.Docs.CapabilitiesConfig]::new([ordered]@{ gizmo = 1 }) } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike '*capabilities configuration validation failed:*'
        $message | Should -Match "unknown top-level key 'gizmo'"
        $message | Should -Match "missing required key 'capabilities'"
    }

    It 'rejects an empty list' {
        { [Catzc.Base.Docs.CapabilitiesConfig]::new([ordered]@{ capabilities = @() }) } |
            Should -Throw '*capabilities must be a non-empty list*'
    }

    It 'collects entry violations by index: a name without a domain, a duplicate, a non-mapping, an empty citation list' {
        $thrown = { [Catzc.Base.Docs.CapabilitiesConfig]::new([ordered]@{
                    capabilities = @(
                        $widget,
                        $widget,
                        'gadget',
                        [ordered]@{ name = 'gadget'; supported_by = @(); checks = @() },
                        [ordered]@{ name = 'gadget-turn'; supported_by = @('ADR-WIDGET-ONE-TURN'); checks = @(); gizmo = 1 }
                    )
                }) } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -Match "capabilities\[1\]: duplicate entry for capability 'widget-spin'"
        $message | Should -Match 'capabilities\[2\] must be a mapping'
        $message | Should -Match "capabilities\[3\]: name 'gadget' must be <domain>-<job>"
        $message | Should -Match "capabilities\[3\]: 'supported_by' must cite at least one rule"
        $message | Should -Match "capabilities\[4\]: unknown key 'gizmo'"
    }
}
