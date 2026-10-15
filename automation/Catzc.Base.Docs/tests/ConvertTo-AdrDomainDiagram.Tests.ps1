<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1
    kind: test
---
#>

# ConvertTo-AdrDomainDiagram — a pure renderer, fed fixture edges and a fixture AdrsConfig for the node roles
# (Get-Config mocked). Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'ConvertTo-AdrDomainDiagram' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Docs.AdrsConfig]::new([ordered]@{
                domains = [ordered]@{
                    widget = [ordered]@{
                        code = 'WI'; role = 'axioms'; description = 'The widget axioms.'; depends_on = @()
                        stack = 'PRIN'; concern = @('build')
                        rulesets = [ordered]@{ 'widget-one' = [ordered]@{ external = 'ADR-WI-ONE' } }
                    }
                    gadget = [ordered]@{
                        code = 'GA'; role = 'gizmo-role'; description = 'The gadget implementation.'; depends_on = @('widget')
                        stack = 'AUTO'; concern = @('automation')
                        rulesets = [ordered]@{ 'gadget-one' = [ordered]@{ external = 'ADR-GA-ONE' } }
                    }
                }
            })
        $script:edges = @([Catzc.Base.Docs.AdrDomainEdge]::new('gadget', 'widget'))
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'adrs' } { $script:fixture }
    }

    It 'renders PlantUML (default) with one dashed dependency arrow per edge' {
        $puml = $script:edges | ConvertTo-AdrDomainDiagram
        $puml | Should -Match '@startuml'
        $puml | Should -Match '@enduml'
        $puml | Should -Match '"gadget" \.\.> "widget"'
    }

    It 'renders Mermaid with role-annotated nodes' {
        $mermaid = $script:edges | ConvertTo-AdrDomainDiagram -As Mermaid
        $mermaid | Should -Match 'flowchart LR'
        $mermaid | Should -Match 'gadget\["gadget<br/>\(gizmo-role\)"\]'
        $mermaid | Should -Match 'gadget --> widget'
    }

    It 'renders a Markdown edge table' {
        $markdown = $script:edges | ConvertTo-AdrDomainDiagram -As Markdown
        $markdown | Should -Match '\| From \| To \|'
        $markdown | Should -Match '\| gadget \| widget \|'
    }
}
