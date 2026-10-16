<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Docs/tests/types/AgentsConfig.Tests.ps1
    folder: tests/types
    name: agents-config-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-docs/tests/types/AgentsConfig.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#3
      - ADR-REPO-AGENTS#2
---
#>

Describe 'AgentsConfig' -Tag 'L0', 'logic', 'ADR-REPO-AGENTS#2' {
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
