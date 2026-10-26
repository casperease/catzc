<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-docs/private/Get-CatsModules.ps1.md"
  header: "generated"
---
#>

function Get-CatsModules {
    [OutputType([object[]])]
    [CmdletBinding()]
    param(
        [string] $ModulesRoot = (Get-CatzcModulesRoot)
    )

    $loaded = foreach ($folder in @(Get-ChildPath -Path $ModulesRoot -Depth 1 -Directory)) {
        $name = [System.IO.Path]::GetFileName("$folder".TrimEnd('\', '/'))
        if ($name.StartsWith('.')) {
            continue
        }
        foreach ($module in @(Get-Module -Name $name)) {
            $from = [System.IO.Path]::GetFullPath([System.IO.Path]::GetDirectoryName($module.Path)).TrimEnd('\', '/')
            if ($from -ieq [System.IO.Path]::GetFullPath("$folder").TrimEnd('\', '/') -and
                [System.IO.Path]::GetExtension($module.Path) -ne '.ps1') {
                $module
            }
        }
    }

    $ret = foreach ($module in ($loaded | Sort-Object Name -Unique)) {
        [pscustomobject]@{
            Module    = $module.Name
            Functions = @($module.ExportedFunctions.Keys | Sort-Object)
        }
    }

    $ret = @($ret)
    , $ret
}
