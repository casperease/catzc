<#
---
catzc:
  immutable:
    with_body_sha: "50f389df2bd2"
  edges:
    test: pwsh/Catzc.Base.ModuleSystem/tests/ConvertTo-ModuleDependencyDiagram.Tests.ps1
    docs: "[ConvertTo-ModuleDependencyDiagram.ps1.md](docs/references/pwsh/catzc-base-modulesystem/ConvertTo-ModuleDependencyDiagram.ps1.md)"
---
#>

function ConvertTo-ModuleDependencyDiagram {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
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
