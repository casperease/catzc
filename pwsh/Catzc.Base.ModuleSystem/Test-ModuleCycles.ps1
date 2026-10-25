<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-module-system/Test-ModuleCycles.ps1.md"
  warning: "Generated Header"
---
#>

function Test-ModuleCycles {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $edges = @(Get-ModuleDependency)
    $adjacency = @{}
    $inDegree = @{}
    foreach ($edge in $edges) {
        foreach ($module in $edge.From, $edge.To) {
            if (-not $adjacency.ContainsKey($module)) {
                $adjacency[$module] = [System.Collections.Generic.List[string]]::new()
                $inDegree[$module] = 0
            }
        }
        $adjacency[$edge.From].Add($edge.To)
        $inDegree[$edge.To]++
    }

    $queue = [System.Collections.Generic.Queue[string]]::new()
    foreach ($module in $inDegree.Keys) {
        if ($inDegree[$module] -eq 0) {
            $queue.Enqueue($module)
        }
    }
    while ($queue.Count -gt 0) {
        $current = $queue.Dequeue()
        foreach ($neighbor in $adjacency[$current]) {
            $inDegree[$neighbor]--
            if ($inDegree[$neighbor] -eq 0) {
                $queue.Enqueue($neighbor)
            }
        }
    }

    $issues = @(foreach ($module in ($inDegree.Keys | Sort-Object)) {
            if ($inDegree[$module] -gt 0) {
                $targets = @($adjacency[$module] | Where-Object { $inDegree[$_] -gt 0 } | Sort-Object -Unique)
                $detail = ''
                if ($targets.Count) {
                    $detail = " (calls into $($targets -join ', '))"
                }
                "${module}: on a dependency cycle, or called from one$detail"
            }
        })

    Write-QualityGateReport -Subject 'module-cycles' -Title 'Test-ModuleCycles' -Issues $issues `
        -Facts ([ordered]@{ Modules = $inDegree.Count; Edges = $edges.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
