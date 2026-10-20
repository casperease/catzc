<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/ConvertTo-AdrDomainDiagram.ps1
    name: convert-to-adr-domain-diagram
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1
    docs: "[ConvertTo-AdrDomainDiagram.ps1.md](docs/references/pwsh/catzc-base-docs/ConvertTo-AdrDomainDiagram.ps1.md)"
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
