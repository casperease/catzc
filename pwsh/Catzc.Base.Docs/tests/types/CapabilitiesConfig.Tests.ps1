# Rests on [ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities) and [ADR-REPO-AGENTS-NOORPHANNOGHOST](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents-noorphannoghost).
Describe 'CapabilitiesConfig' -Tag 'L0', 'logic', 'ADR-REPO-AGENTS-CAPABILITYREGISTERED' {
    BeforeAll {
        $script:widget = [ordered]@{ name = 'widget-spin'; supported_by = @('ADR-WI-ONE#1'); checks = @('Test-Widget') }
        $script:gadget = [ordered]@{ name = 'gadget-turn-fast'; supported_by = @('ADR-WI-ONE#2'); checks = @() }
    }

    It 'constructs and exposes the capabilities in file order' {
        $config = [Catzc.Base.Docs.CapabilitiesConfig]::new([ordered]@{ capabilities = @($widget, $gadget) })
        $config.capabilities.name | Should -Be @('widget-spin', 'gadget-turn-fast')
        $config.capabilities[0] | Should -BeOfType ([Catzc.Base.Docs.CapabilityEntry])
        $config.capabilities[0].checks | Should -Be @('Test-Widget')
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
                        [ordered]@{ name = 'gadget-turn'; supported_by = @('ADR-WI-ONE#1'); checks = @(); gizmo = 1 }
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
