<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1
    kind: function
    subkind: gate
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.ModuleSystem/tests/Test-ModuleCycles.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#35
  config:
    synopsis: 'Quality gate: the real module-to-module call graph has no cycle.'
    description: |-
      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the actual
      cross-module function calls (Get-ModuleDependency). It sorts the graph topologically (Kahn's algorithm) and
      reports every module the sort cannot place — each sits on a dependency cycle or is called from one.

      This is the whole graph, every module included: Test-ModuleDependency checks the declared modules' edges against
      the allow-list in configs/dependencies.yml, and an unconstrained module is outside that list, so a cycle through
      one is caught only here. It analyses the per-function source files (Get-ModuleDependency).
    parameters:
      OutputFolder: The report base folder. Defaults to out/test-module-cycles/ (Write-QualityGateReport).
      PassThru: Return the result ({ Subject; IssueCount; Issues; ReportPath; Modules; Edges }) instead of throwing on issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-ModuleCycles
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
