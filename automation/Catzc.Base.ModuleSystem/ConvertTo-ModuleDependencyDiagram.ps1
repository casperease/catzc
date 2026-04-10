<#
.SYNOPSIS
    Renders module dependency edges to JSON, YAML, Markdown, or PlantUML.
.DESCRIPTION
    Serializes ModuleDependencyEdge objects (from Get-ModuleDependencyEdges) to the format chosen by -As:

      - Puml     — a `@startuml … @enduml` graph for visualization (a solid arrow per actual edge,
                   labelled with the call count; a dashed arrow per declared/allowed edge).
      - Markdown — a `| From | To | Kind | Calls |` table.
      - Json     — the edge objects as JSON.
      - Yaml     — the edges as a YAML sequence of `from/to/kind/call_count` maps.

    The format is a typed parameter (ModuleDependencyFormat), so `-As <TAB>` validates and tab-completes.
.PARAMETER Edge
    The edges to render (pipeline). Produced by Get-ModuleDependencyEdges.
.PARAMETER As
    Output format: Json | Yaml | Markdown | Puml. Defaults to Puml.
.EXAMPLE
    Get-ModuleDependencyEdges | ConvertTo-ModuleDependencyDiagram -As Puml
.EXAMPLE
    Get-ModuleDependencyEdges -Declared | ConvertTo-ModuleDependencyDiagram -As Markdown
#>
function ConvertTo-ModuleDependencyDiagram {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [Catzc.Base.ModuleSystem.ModuleDependencyEdge[]] $Edge,

        [Catzc.Base.ModuleSystem.ModuleDependencyFormat] $As = [Catzc.Base.ModuleSystem.ModuleDependencyFormat]::Puml
    )

    begin {
        $edges = [System.Collections.Generic.List[Catzc.Base.ModuleSystem.ModuleDependencyEdge]]::new()
    }
    process {
        foreach ($e in $Edge) {
            $edges.Add($e)
        }
    }
    end {
        $lines = [System.Collections.Generic.List[string]]::new()

        switch ($As) {
            'Json' {
                return ($edges | Select-Object From, To, Kind, CallCount, Functions | ConvertTo-Json -Depth 5)
            }
            'Yaml' {
                foreach ($e in $edges) {
                    $lines.Add("- from: $($e.From)")
                    $lines.Add("  to: $($e.To)")
                    $lines.Add("  kind: $($e.Kind)")
                    $lines.Add("  call_count: $($e.CallCount)")
                }
            }
            'Markdown' {
                $lines.Add('| From | To | Kind | Calls |')
                $lines.Add('| ---- | -- | ---- | ----- |')
                foreach ($e in $edges) {
                    $lines.Add("| $($e.From) | $($e.To) | $($e.Kind) | $($e.CallCount) |")
                }
            }
            'Puml' {
                $lines.Add('@startuml')
                $lines.Add('left to right direction')
                foreach ($e in $edges) {
                    $arrow = if ($e.Kind -eq 'declared') {
                        '..>'
                    }
                    else {
                        '-->'
                    }
                    $label = if ($e.CallCount -gt 0) {
                        " : $($e.CallCount)"
                    }
                    else {
                        ''
                    }
                    $lines.Add("`"$($e.From)`" $arrow `"$($e.To)`"$label")
                }
                $lines.Add('@enduml')
            }
        }

        $lines -join [Environment]::NewLine
    }
}
