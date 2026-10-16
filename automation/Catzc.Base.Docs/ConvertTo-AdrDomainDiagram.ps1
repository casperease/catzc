<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Docs/ConvertTo-AdrDomainDiagram.ps1
    name: convert-to-adr-domain-diagram
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1
  config:
    synopsis: Renders ADR domain dependency edges to PlantUML, Mermaid, or a Markdown table.
    description: |-
      Serializes the edges from Get-AdrDomainEdges to the format chosen by -As — the ADR-domain counterpart of
      ConvertTo-ModuleDependencyDiagram, so the domain DAG (which the ASM/flow reasoning depends on) is drawn the
      same way the module graph is:

        - Puml     — a `@startuml … @enduml` graph (a dashed arrow per declared edge).
        - Mermaid  — a `flowchart LR` graph for inline rendering in Markdown.
        - Markdown — a `| From | To |` table.

      Each domain's `role` (from Get-Config -Config adrs) annotates its node, so a reader sees which domains are
      axioms / architecture / implementation / reference at a glance.
    parameters:
      Edge: The edges to render (pipeline), as Catzc.Base.Docs.AdrDomainEdge. Produced by Get-AdrDomainEdges.
      As: 'Output format: Puml | Mermaid | Markdown. Defaults to Puml.'
    examples:
      - Get-AdrDomainEdges | ConvertTo-AdrDomainDiagram -As Mermaid
---
#>

function ConvertTo-AdrDomainDiagram {
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [Catzc.Base.Docs.AdrDomainEdge[]] $Edge,

        [ValidateSet('Puml', 'Mermaid', 'Markdown')]
        [string] $As = 'Puml'
    )

    begin {
        $edges = [System.Collections.Generic.List[Catzc.Base.Docs.AdrDomainEdge]]::new()
    }
    process {
        foreach ($item in $Edge) {
            $edges.Add($item)
        }
    }
    end {
        $roles = @{}
        foreach ($domain in (Get-Config -Config adrs).Domains) {
            $roles[$domain.Name] = $domain.Role
        }

        $lines = [System.Collections.Generic.List[string]]::new()
        switch ($As) {
            'Markdown' {
                $lines.Add('| From | To |')
                $lines.Add('| ---- | -- |')
                foreach ($e in $edges) {
                    $lines.Add("| $($e.From) | $($e.To) |")
                }
            }
            'Mermaid' {
                $lines.Add('```mermaid')
                $lines.Add('flowchart LR')
                foreach ($node in @($roles.Keys)) {
                    $lines.Add("  $node[""$node<br/>($($roles[$node]))""]")
                }
                foreach ($e in $edges) {
                    $lines.Add("  $($e.From) --> $($e.To)")
                }
                $lines.Add('```')
            }
            'Puml' {
                $lines.Add('@startuml')
                $lines.Add('left to right direction')
                foreach ($e in $edges) {
                    $lines.Add("`"$($e.From)`" ..> `"$($e.To)`"")
                }
                $lines.Add('@enduml')
            }
        }
        $lines -join [Environment]::NewLine
    }
}
