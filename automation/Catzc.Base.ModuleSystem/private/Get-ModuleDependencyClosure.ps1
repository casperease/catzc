<#
.SYNOPSIS
    Returns the transitive declared-dependency closure of a set of modules — the seeds plus every module they
    depend on (directly or indirectly), per configs/dependencies.yml.
.DESCRIPTION
    Breadth-first over the declared dependency map (Get-ModuleDependencyMap).
    [comment:1](/docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyClosure.ps1.md#comment1)
.PARAMETER Module
    The seed module names to close over.
.EXAMPLE
    Get-ModuleDependencyClosure -Module Catzc.Azure.Templates
    # -> Catzc.Azure.Templates plus its Base/Tooling/Catzc.Azure dependencies
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
