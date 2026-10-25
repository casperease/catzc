<#
---
catzc:
  docs: "../../../../docs/references/pwsh/catzc-base-docs/tests/types/AgentEntry.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'AgentEntry' -Tag 'L0', 'logic', 'ADR-REPO-AGENTS-BACKEDBYRULE' {
    It 'constructs and exposes name, supported_by, and checks' {
        $entry = [Catzc.Base.Docs.AgentEntry]::new([ordered]@{
                name = 'widget-worker'; supported_by = @('ADR-WIDGET-ONE-TURN', 'ADR-WIDGET-TWO-PARTS-SPIN'); checks = @('Test-Widget', 'Invoke-Gadget')
            })
        $entry.name | Should -Be 'widget-worker'
        $entry.supported_by | Should -Be @('ADR-WIDGET-ONE-TURN', 'ADR-WIDGET-TWO-PARTS-SPIN')
        $entry.checks | Should -Be @('Test-Widget', 'Invoke-Gadget')
    }

    It 'accepts an empty checks list' {
        $entry = [Catzc.Base.Docs.AgentEntry]::new([ordered]@{ name = 'gadget'; supported_by = @('ADR-WIDGET-ONE-TURN'); checks = @() })
        $entry.checks | Should -HaveCount 0
    }

    It 'carries a persona when the robot keeps a log, and rejects one that is no person name' {
        $entry = [Catzc.Base.Docs.AgentEntry]::new([ordered]@{ name = 'gadget'; supported_by = @('ADR-WIDGET-ONE-TURN'); checks = @(); persona = 'Susan from HR' })
        $entry.persona | Should -BeExactly 'Susan from HR'
        $plain = [Catzc.Base.Docs.AgentEntry]::new([ordered]@{ name = 'gadget'; supported_by = @('ADR-WIDGET-ONE-TURN'); checks = @() })
        $plain.persona | Should -BeNullOrEmpty
        $thrown = { [Catzc.Base.Docs.AgentEntry]::new([ordered]@{ name = 'gadget'; supported_by = @('ADR-WIDGET-ONE-TURN'); checks = @(); persona = 'gadget-1' }) } |
            Should -Throw -PassThru
        $thrown.Exception.Message | Should -Match "persona 'gadget-1' must be a capitalised person name"
    }

    It 'presents as a read-only dictionary (DictionaryRecord)' {
        $entry = [Catzc.Base.Docs.AgentEntry]::new([ordered]@{ name = 'gadget'; supported_by = @('ADR-WIDGET-ONE-TURN'); checks = @() })
        $entry.Contains('name') | Should -BeTrue
        $entry['name'] | Should -Be 'gadget'
    }

    It 'collects every violation into one ArgumentException' {
        $thrown = { [Catzc.Base.Docs.AgentEntry]::new([ordered]@{
                    name = 'Widget_Worker'; supported_by = @('ADR-WIDGET', 'ADR-WIDGET-ONE-TURN', 'ADR-WIDGET-ONE-TURN'); checks = @('widget'); gizmo = 1
                }) } | Should -Throw -PassThru
        $thrown.Exception.InnerException | Should -BeOfType ([System.ArgumentException])
        $message = $thrown.Exception.Message
        $message | Should -Match "unknown key 'gizmo'"
        $message | Should -Match "name 'Widget_Worker' must be kebab-case"
        $message | Should -Match "supported_by entry 'ADR-WIDGET' must be a rule's code"
        $message | Should -Match "supported_by entry 'ADR-WIDGET-ONE-TURN' is repeated"
        $message | Should -Match "checks entry 'widget' must be a Verb-Noun command name"
    }

    It 'requires name, supported_by, and checks' {
        $thrown = { [Catzc.Base.Docs.AgentEntry]::new([ordered]@{}) } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -Match "'name' is required"
        $message | Should -Match "'supported_by' is required"
        $message | Should -Match "'checks' is required"
    }

    It 'rejects an empty supported_by and a scalar checks' {
        $thrown = { [Catzc.Base.Docs.AgentEntry]::new([ordered]@{ name = 'gadget'; supported_by = @(); checks = 'Test-Widget' }) } |
            Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -Match "'supported_by' must cite at least one rule"
        $message | Should -Match "'checks' must be a list"
    }
}
