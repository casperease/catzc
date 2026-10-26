<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-module-system/private/Get-ModuleDependencyClosure.ps1.md"
  header: "generated"
---
#>

function Get-ModuleDependencyClosure {
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Module
    )

    $dependencyMap = Get-ModuleDependencyMap
    $closure = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $queue = [System.Collections.Generic.Queue[string]]::new()

    foreach ($seed in $Module) {
        if ($seed -and $closure.Add($seed)) {
            $queue.Enqueue($seed)
        }
    }
    while ($queue.Count -gt 0) {
        $current = $queue.Dequeue()
        if ($dependencyMap.ContainsKey($current)) {
            foreach ($dependency in $dependencyMap[$current]) {
                if ($closure.Add($dependency)) {
                    $queue.Enqueue($dependency)
                }
            }
        }
    }

    $ret = [string[]] @($closure)
    [System.Array]::Sort($ret, [System.StringComparer]::Ordinal)
    $ret
}
