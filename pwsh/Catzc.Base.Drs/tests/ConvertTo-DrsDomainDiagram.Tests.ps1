<#
---
catzc:
  immutable:
    with_body_sha: b4cf8c35f1a8
  edges:
    docs: "[ConvertTo-DrsDomainDiagram.Tests.ps1.md](docs/references/pwsh/catzc-base-drs/tests/ConvertTo-DrsDomainDiagram.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Drs/ConvertTo-DrsDomainDiagram.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
---
#>

Describe 'ConvertTo-DrsDomainDiagram' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fixture = [Catzc.Base.Drs.DrsConfig]::new([ordered]@{
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
        $script:edges = @([Catzc.Base.Drs.DrsDomainEdge]::new('gadget', 'widget'))
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Drs -ParameterFilter { $Config -eq 'drs' } { $script:fixture }
    }

    It 'renders PlantUML (default) with one dashed dependency arrow per edge' {
        $puml = $script:edges | ConvertTo-DrsDomainDiagram
        $puml | Should -Match '@startuml'
        $puml | Should -Match '@enduml'
        $puml | Should -Match '"gadget" \.\.> "widget"'
    }

    It 'renders Mermaid with role-annotated nodes' {
        $mermaid = $script:edges | ConvertTo-DrsDomainDiagram -As Mermaid
        $mermaid | Should -Match 'flowchart LR'
        $mermaid | Should -Match 'gadget\["gadget<br/>\(gizmo-role\)"\]'
        $mermaid | Should -Match 'gadget --> widget'
    }

    It 'renders a Markdown edge table' {
        $markdown = $script:edges | ConvertTo-DrsDomainDiagram -As Markdown
        $markdown | Should -Match '\| From \| To \|'
        $markdown | Should -Match '\| gadget \| widget \|'
    }
}
