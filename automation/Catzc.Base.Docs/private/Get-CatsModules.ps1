<#
.SYNOPSIS
    Lists the loaded catzc modules and the public functions each exports, for Show-Cats.
.DESCRIPTION
    Reads the loaded session: every module whose folder sits directly under the code root (Get-CatzcModulesRoot) and...
    [ADR-REPO-FOLDERS#4](/docs/adr/repository/conventional-folders.md#rule-adr-repo-folders4),
    [ADR-DSGN-RUNMODE#2](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode2)
    [comment:1](/docs/references/automation/catzc-base-docs/private/Get-CatsModules.ps1.md#comment1)
.PARAMETER ModulesRoot
    The code root whose loaded modules to list.
    [comment:2](/docs/references/automation/catzc-base-docs/private/Get-CatsModules.ps1.md#comment2)
.OUTPUTS
    [object[]] One { Module; Functions } per module, sorted by module name, each Functions list sorted.
#>
function Get-CatsModules {
    [OutputType([object[]])]
    [CmdletBinding()]
    param(
        [string] $ModulesRoot = (Get-CatzcModulesRoot)
    )

    $root = [System.IO.Path]::GetFullPath($ModulesRoot).TrimEnd('\', '/')

    # Called from inside a module, Get-Module also lists that module's own nested.ps1 function files (one per...
    # [comment:3](/docs/references/automation/catzc-base-docs/private/Get-CatsModules.ps1.md#comment3)
    $loaded = foreach ($module in (Get-Module)) {
        if (-not $module.ModuleBase -or $module.Name.StartsWith('.')) {
            continue
        }
        $base = [System.IO.Path]::GetFullPath($module.ModuleBase).TrimEnd('\', '/')
        if ([System.IO.Path]::GetDirectoryName($base) -ine $root) {
            continue
        }
        if ([System.IO.Path]::GetFileName($base) -ne $module.Name -or [System.IO.Path]::GetExtension($module.Path) -eq '.ps1') {
            continue
        }
        $module
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
