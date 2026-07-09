Describe 'ConvertTo-AdrDomainDiagram' -Tag 'L1', 'integrity' {
    BeforeAll {
        $script:edges = Get-AdrDomainEdges
    }

    It 'renders PlantUML (default) with dashed dependency arrows' {
        $puml = $script:edges | ConvertTo-AdrDomainDiagram
        $puml | Should -Match '@startuml'
        $puml | Should -Match '@enduml'
        $puml | Should -Match '\.\.>'
    }

    It 'renders Mermaid with role-annotated nodes' {
        $mermaid = $script:edges | ConvertTo-AdrDomainDiagram -As Mermaid
        $mermaid | Should -Match 'flowchart LR'
        $mermaid | Should -Match 'reference'   # the research domain's role
        $mermaid | Should -Match '-->'
    }

    It 'renders a Markdown edge table' {
        $markdown = $script:edges | ConvertTo-AdrDomainDiagram -As Markdown
        $markdown | Should -Match '\| From \| To \|'
    }
}
