<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-module-system/Get-ModuleDependency.ps1.md"
  header: "generated"
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
