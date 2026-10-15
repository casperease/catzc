<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
    kind: function
    module: Catzc.Base.Docs
    visibility: private
    adrs:
      - ADR-DSGN-RUNMODE#2
      - ADR-REPO-FOLDERS#4
---
#>

<#
.SYNOPSIS
    Lists the loaded catzc modules and the public functions each exports, for Show-Cats.
.DESCRIPTION
    Reads what is loaded, not the per-function files, so both run modes give the same answer.
.PARAMETER ModulesRoot
    A test points this at a fixture root from which it loaded fixture modules.
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

    # Get-Module also lists a module's nested .ps1 files, so keep only the entry named for its folder.
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
