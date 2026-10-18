Describe 'AgentsConfig' -Tag 'L0', 'logic', 'ADR-REPO-AGENTS-BACKEDBYRULE' {
    BeforeAll {
        $script:widget = [ordered]@{ name = 'widget'; supported_by = @('ADR-WI-ONE#1'); checks = @('Test-Widget') }
        $script:gadget = [ordered]@{ name = 'gadget'; supported_by = @('ADR-WI-ONE#2'); checks = @() }
    }

    It 'constructs and exposes standard and the agents in file order' {
        $config = [Catzc.Base.Docs.AgentsConfig]::new([ordered]@{ standard = 'widget'; agents = @($widget, $gadget) })
        $config.standard | Should -Be 'widget'
        $config.agents.name | Should -Be @('widget', 'gadget')
        $config.agents[0] | Should -BeOfType ([Catzc.Base.Docs.AgentEntry])
    }

    It 'presents as a read-only dictionary (DictionaryRecord)' {
        $config = [Catzc.Base.Docs.AgentsConfig]::new([ordered]@{ standard = 'widget'; agents = @($widget) })
        $config.Contains('agents') | Should -BeTrue
        $config['standard'] | Should -Be 'widget'
    }

    It 'requires standard and agents and rejects an unknown key' {
        $thrown = { [Catzc.Base.Docs.AgentsConfig]::new([ordered]@{ gizmo = 1 }) } |
            Should -Throw -PassThru
        $thrown.Exception.InnerException | Should -BeOfType ([System.ArgumentException])
        $message = $thrown.Exception.Message
        $message | Should -BeLike '*agents configuration validation failed:*'
        $message | Should -Match "unknown top-level key 'gizmo'"
        $message | Should -Match "missing required key 'standard'"
        $message | Should -Match "missing required key 'agents'"
    }

    It 'declares the roofs once as defaults and takes an override from roofs' -Tag 'ADR-REPO-AGENTS-ROBOTBODYLIMIT', 'ADR-REPO-AGENTS-CAPABILITYFILE' {
        $default = [Catzc.Base.Docs.AgentsConfig]::new([ordered]@{ standard = 'widget'; agents = @($widget) })
        $default.agent_body_lines | Should -Be 20
        $default.capability_lines | Should -Be 10
        $set = [Catzc.Base.Docs.AgentsConfig]::new([ordered]@{ standard = 'widget'; agents = @($widget); roofs = [ordered]@{ agent_body_lines = 12 } })
        $set.agent_body_lines | Should -Be 12
        $set.capability_lines | Should -Be 10
        $thrown = { [Catzc.Base.Docs.AgentsConfig]::new([ordered]@{ standard = 'widget'; agents = @($widget); roofs = [ordered]@{ capability_lines = 0; gizmo = 1 } }) } |
            Should -Throw -PassThru
        $thrown.Exception.Message | Should -Match 'roofs: capability_lines must be a positive integer'
        $thrown.Exception.Message | Should -Match "roofs: unknown key 'gizmo'"
    }

    It 'keeps model_reason optional and rejects it empty' -Tag 'ADR-REPO-AGENTS-NAMEDMODEL' {
        $reasoned = [ordered]@{ name = 'widget'; supported_by = @('ADR-WI-ONE#1'); checks = @(); model_reason = 'judges across files' }
        $config = [Catzc.Base.Docs.AgentsConfig]::new([ordered]@{ standard = 'widget'; agents = @($reasoned, $gadget) })
        $config.agents[0].model_reason | Should -Be 'judges across files'
        $config.agents[1].model_reason | Should -BeNullOrEmpty
        $empty = [ordered]@{ name = 'widget'; supported_by = @('ADR-WI-ONE#1'); checks = @(); model_reason = '' }
        { [Catzc.Base.Docs.AgentsConfig]::new([ordered]@{ standard = 'widget'; agents = @($empty) }) } |
            Should -Throw "*'model_reason' is empty*"
    }

    It 'declares the required contracts once as a default and takes an override' -Tag 'ADR-REPO-AGENTS-ROBOTBODYLIMIT' {
        $default = [Catzc.Base.Docs.AgentsConfig]::new([ordered]@{ standard = 'widget'; agents = @($widget) })
        $default.contracts | Should -Be @('ADR-REPO-AI')
        $set = [Catzc.Base.Docs.AgentsConfig]::new([ordered]@{ standard = 'widget'; agents = @($widget); contracts = @('ADR-WI', 'ADR-GA') })
        $set.contracts | Should -Be @('ADR-WI', 'ADR-GA')
        $thrown = { [Catzc.Base.Docs.AgentsConfig]::new([ordered]@{ standard = 'widget'; agents = @($widget); contracts = @('ADR-WI#1') }) } |
            Should -Throw -PassThru
        $thrown.Exception.Message | Should -Match "contracts entry 'ADR-WI#1' must be a bare ADR code"
    }

    It 'rejects an empty agents list' {
        { [Catzc.Base.Docs.AgentsConfig]::new([ordered]@{ standard = 'widget'; agents = @() }) } |
            Should -Throw '*agents must be a non-empty list*'
    }

    It 'collects entry violations by index, a duplicate name, and a standard that names no entry' {
        $thrown = { [Catzc.Base.Docs.AgentsConfig]::new([ordered]@{
                    standard = 'gizmo'
                    agents   = @($widget, $widget, 'gadget', [ordered]@{ name = 'gadget'; supported_by = @(); checks = @() })
                }) } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -Match "agents\[1\]: duplicate entry for agent 'widget'"
        $message | Should -Match 'agents\[2\] must be a mapping'
        $message | Should -Match "agents\[3\]: 'supported_by' must cite at least one rule"
        $message | Should -Match "standard 'gizmo' names no entry in agents"
    }
}
