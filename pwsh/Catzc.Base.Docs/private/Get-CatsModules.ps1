<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/private/Get-CatsModules.ps1
    folder: private
    name: get-cats-modules
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Get-CatsModules.Tests.ps1
    docs: "[Get-CatsModules.ps1.md](docs/references/pwsh/catzc-base-docs/private/Get-CatsModules.ps1.md)"
    cites:
      - ADR-DSGN-RUNMODE-SAMEMODULEINBOTH
      - ADR-REPO-FOLDERS-DOTMEANSTOOLING
---
#>

function Get-CatsModules {
    [OutputType([object[]])]
    [CmdletBinding()]
    param(
        [string] $ModulesRoot = (Get-CatzcModulesRoot)
    )

    $root = [System.IO.Path]::GetFullPath($ModulesRoot).TrimEnd('\', '/')

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
