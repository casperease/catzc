<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1
    name: test-module-cycles
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.ModuleSystem/tests/Test-ModuleCycles.Tests.ps1
    cites:
      - ADR-AUTO-TEST#35
---
#>

function Test-ModuleCycles {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
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
