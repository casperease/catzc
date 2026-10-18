Describe 'ConvertTo-ModuleDependencyDiagram' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:edges = @(
            [Catzc.Base.ModuleSystem.ModuleDependencyEdge]::new('Catzc.A', 'Catzc.B', 'actual', 2, @('f->g:1'))
            [Catzc.Base.ModuleSystem.ModuleDependencyEdge]::new('Catzc.B', 'Catzc.C', 'declared', 0, @())
        )
    }

    It 'renders PlantUML with a solid labelled actual edge and a dashed declared edge' {
        $puml = $script:edges | ConvertTo-ModuleDependencyDiagram -As Puml
        $puml | Should -Match '@startuml'
        $puml | Should -Match '@enduml'
        $puml | Should -Match '"Catzc\.A" --> "Catzc\.B" : 2'
        $puml | Should -Match '"Catzc\.B" \.\.> "Catzc\.C"'
    }

    It 'defaults to Puml' {
        ($script:edges | ConvertTo-ModuleDependencyDiagram) | Should -Match '@startuml'
    }

    It 'renders JSON that parses back to the edges' {
        $parsed = @($script:edges | ConvertTo-ModuleDependencyDiagram -As Json | ConvertFrom-Json)
        $parsed.Count | Should -Be 2
        $parsed[0].From | Should -Be 'Catzc.A'
        $parsed[0].CallCount | Should -Be 2
    }

    It 'renders a Markdown table' {
        $md = $script:edges | ConvertTo-ModuleDependencyDiagram -As Markdown
        $md | Should -Match '\| From \| To \| Kind \| Calls \|'
        $md | Should -Match '\| Catzc\.A \| Catzc\.B \| actual \| 2 \|'
    }

    It 'renders YAML with from/to/kind/call_count keys' {
        $yaml = $script:edges | ConvertTo-ModuleDependencyDiagram -As Yaml
        $yaml | Should -Match 'from: Catzc\.A'
        $yaml | Should -Match 'to: Catzc\.B'
        $yaml | Should -Match 'kind: declared'
        $yaml | Should -Match 'call_count: 0'
    }

    It 'rejects an invalid -As value (typed parameter)' {
        { $script:edges | ConvertTo-ModuleDependencyDiagram -As Xml } | Should -Throw
    }
}
