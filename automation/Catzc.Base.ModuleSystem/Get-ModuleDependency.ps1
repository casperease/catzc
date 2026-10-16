<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.ModuleSystem/Get-ModuleDependency.ps1
    name: get-module-dependency
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.ModuleSystem/tests/Get-ModuleDependency.Tests.ps1
  config:
    synopsis: Compiles a module-level dependency edge map from function-level dependencies.
    description: |-
      Takes the output of Get-FunctionDependency and collapses it into unique
      module-to-module edges with call counts and the functions involved.
    parameters:
      Dependency: Function dependency objects from Get-FunctionDependency. Accepts pipeline input.
    examples:
      - Get-FunctionDependency | Get-ModuleDependency
      - Get-FunctionDependency | Get-ModuleDependency | Where-Object { $_.From -eq 'Catzc.Tooling.Core' }
---
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
