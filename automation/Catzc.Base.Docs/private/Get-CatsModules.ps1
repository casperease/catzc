<#
.SYNOPSIS
    Lists the loaded catzc modules and the public functions each exports, for Show-Cats.
.DESCRIPTION
    Reads the loaded session: every module whose folder sits directly under the code root (Get-CatzcModulesRoot)
    and is not dot-prefixed (a dot-prefix means infrastructure, ADR-REPO-FOLDERS:4), with the functions it exports.
    Because it reads what is loaded rather than the per-function files, the answer is the same in source mode and
    in build mode, where each module's functions are merged into one file (ADR-DSGN-RUNMODE:2). Private functions
    are never exported, so they never appear.

    Private helper for Show-Cats; not exported.
.PARAMETER ModulesRoot
    The code root whose loaded modules to list. Defaults to Get-CatzcModulesRoot. A test points this at a fixture
    root from which it loaded fixture modules.
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

    # Called from inside a module, Get-Module also lists that module's own nested .ps1 function files (one per
    # function in source mode, the merged <Module>.ps1 in build mode). A module is its folder (folder = module),
    # so keep only the entry named for its folder whose root file is not a nested .ps1.
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
