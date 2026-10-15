<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-CatsModules.ps1
    kind: private-function
    module: Catzc.Base.Docs
    visibility: private
    adrs:
      - ADR-DSGN-RUNMODE#2
      - ADR-REPO-FOLDERS#4
  config:
    synopsis: Lists the loaded catzc modules and the public functions each exports, for Show-Cats.
    description: |-
      Reads the loaded session: every module whose folder sits directly under the code root (Get-CatzcModulesRoot)
      and is not dot-prefixed (a dot-prefix means infrastructure,
      [ADR-REPO-FOLDERS#4](/docs/adr/repository/conventional-folders.md#rule-adr-repo-folders4)), with the functions it
      exports.
      Because it reads what is loaded rather than the per-function files, the answer is the same in source mode and
      in build mode, where each module's functions are merged into one file
      ([ADR-DSGN-RUNMODE#2](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode2)). Private functions
      are never exported, so they never appear.

      Private helper for Show-Cats; not exported.
    parameters:
      ModulesRoot: |-
        The code root whose loaded modules to list. Defaults to Get-CatzcModulesRoot. A test points this at a fixture
        root from which it loaded fixture modules.
    outputs: '[object[]] One { Module; Functions } per module, sorted by module name, each Functions list sorted.'
---
#>

function Get-CatsModules {
    [OutputType([object[]])]
    [CmdletBinding()]
    param(
        [string] $ModulesRoot = (Get-CatzcModulesRoot)
    )

    $root = [System.IO.Path]::GetFullPath($ModulesRoot).TrimEnd('\', '/')

    # Called from inside a module, Get-Module also lists that module's own nested.ps1 function files (one per...
    # [comment:4](/docs/references/automation/catzc-base-docs/private/Get-CatsModules.ps1.md#comment4)
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
