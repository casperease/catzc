<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.ModuleSystem/Get-ModuleDependency.ps1
    name: get-module-dependency
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.ModuleSystem/tests/Get-ModuleDependency.Tests.ps1
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
