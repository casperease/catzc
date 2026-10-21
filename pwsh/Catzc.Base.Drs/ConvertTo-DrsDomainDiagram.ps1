<#
---
catzc:
  immutable:
    with_body_sha: b602c371fec0
  edges:
    test: pwsh/Catzc.Base.Drs/tests/ConvertTo-DrsDomainDiagram.Tests.ps1
    docs: "[ConvertTo-DrsDomainDiagram.ps1.md](../../docs/references/pwsh/catzc-base-drs/ConvertTo-DrsDomainDiagram.ps1.md)"
---
#>

function ConvertTo-DrsDomainDiagram {
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [Catzc.Base.Drs.DrsDomainEdge[]] $Edge,

        [ValidateSet('Puml', 'Mermaid', 'Markdown')]
        [string] $As = 'Puml'
    )

    begin {
        $edges = [System.Collections.Generic.List[Catzc.Base.Drs.DrsDomainEdge]]::new()
    }
    process {
        foreach ($item in $Edge) {
            $edges.Add($item)
        }
    }
    end {
        $roles = @{}
        foreach ($domain in (Get-Config -Config drs).Domains) {
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
