<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyClosure.ps1
    folder: private
    name: get-module-dependency-closure
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.ModuleSystem/tests/Get-ModuleDependencyClosure.Tests.ps1
    docs: "[Get-ModuleDependencyClosure.ps1.md](docs/references/pwsh/catzc-base-modulesystem/private/Get-ModuleDependencyClosure.ps1.md)"
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
