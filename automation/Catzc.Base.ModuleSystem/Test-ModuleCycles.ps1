<#
.SYNOPSIS
    Quality gate: the real module-to-module call graph has no cycle.
.DESCRIPTION
    A quality gate over the actual cross-module function calls (Get-ModuleDependency).
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)
    [comment:1](/docs/references/automation/catzc-base-modulesystem/Test-ModuleCycles.ps1.md#comment1)
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-module-cycles/ (Write-QualityGateReport).
.PARAMETER PassThru
    Return the result ({ Subject; IssueCount; Issues; ReportPath; Modules; Edges }) instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-ModuleCycles
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
