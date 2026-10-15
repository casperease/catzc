<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/Get-ModuleDependency.ps1
    kind: function
    module: Catzc.Base.ModuleSystem
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Compiles a module-level dependency edge map from function-level dependencies.
.DESCRIPTION
    Calls within one module never appear: only calls crossing a module boundary count toward an edge.
.PARAMETER Dependency
    Function dependency objects from Get-FunctionDependency. Accepts pipeline input.
.EXAMPLE
    Get-FunctionDependency | Get-ModuleDependency
.EXAMPLE
    Get-FunctionDependency | Get-ModuleDependency | Where-Object { $_.From -eq 'Catzc.Tooling.Core' }
#>
function Get-ModuleDependency {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject[]] $Dependency
    )

    begin {
        $all = [System.Collections.Generic.List[PSObject]]::new()
    }
    process {
        foreach ($d in $Dependency) {
            $all.Add($d)
        }
    }
    end {
        if ($all.Count -eq 0) {
            $all.AddRange([PSObject[]](Get-FunctionDependency))
        }

        $all |
            Where-Object CrossModule |
            Group-Object CallerModule, TargetModule |
            ForEach-Object {
                $parts = $_.Name -split ',\s*'
                $functions = $_.Group | ForEach-Object {
                    '{0}->{1}:{2}' -f $_.CallerFunction, $_.TargetFunction, $_.CallerLine
                }
                [PSCustomObject]@{
                    From      = $parts[0]
                    To        = $parts[1]
                    CallCount = $_.Count
                    Functions = $functions
                }
            } |
            Sort-Object From, To
    }
}
