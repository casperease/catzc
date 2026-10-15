<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/Get-BaseModule.ps1
    kind: function
    module: Catzc.Base.ModuleSystem
    visibility: public
    adrs:
      - ADR-AUTO-TYPES#9
      - ADR-DSGN-RUNMODE
---
#>

<#
.SYNOPSIS
    Returns the automation modules as typed BaseModule objects, by kind — the native model type.
.DESCRIPTION
    Classifies against the code root, not the repository root, so build mode (the built package) answers right.
.PARAMETER Kind
    One or more of named, hidden, imported, vendored, builtin, residue. Default: named, hidden.
.EXAMPLE
    Get-BaseModule                                              # on-disk modules (named + hidden), with packages
.EXAMPLE
    Get-BaseModule -Kind imported, vendored, builtin, residue |
        Group-Object Kind                                      # map every loaded module by how it came into play
#>
function Get-BaseModule {
    [CmdletBinding()]
    [OutputType([Catzc.Base.ModuleSystem.BaseModule[]])]
    param(
        [ValidateSet('named', 'hidden', 'imported', 'vendored', 'builtin', 'residue')]
        [string[]] $Kind = @('named', 'hidden')
    )

    $diskKinds = @('named', 'hidden')
    $sessionKinds = @('imported', 'vendored', 'builtin', 'residue')
    $ret = [System.Collections.Generic.List[Catzc.Base.ModuleSystem.BaseModule]]::new()
    $modulesRoot = Get-CatzcModulesRoot

    # ---- on-disk: named + hidden folders under automation/, with their files.yml packages ----
    if ($Kind | Where-Object { $_ -in $diskKinds }) {
        $bindings = (Get-Config -Config files).modules
        # Ordinal sort for a deterministic, culture-independent order (cross-platform).
        $names = [string[]] @(
            [System.IO.Directory]::EnumerateDirectories($modulesRoot) |
                ForEach-Object { [System.IO.Path]::GetFileName($_) }
        )
        [System.Array]::Sort($names, [System.StringComparer]::Ordinal)

        foreach ($name in $names) {
            $isHidden = $name.StartsWith('.')
            $moduleKind = if ($isHidden) {
                'hidden'
            }
            else {
                'named'
            }
            if ($moduleKind -notin $Kind) {
                continue
            }
            $packages = [System.Collections.Generic.List[Catzc.Base.ModuleSystem.ModulePackage]]::new()
            if ($bindings.Contains($name)) {
                $packageMap = $bindings[$name].packages
                foreach ($packageName in $packageMap.Keys) {
                    $paths = [string[]] @($packageMap[$packageName])
                    $packages.Add([Catzc.Base.ModuleSystem.ModulePackage]::new($packageName, $paths))
                }
            }
            $ret.Add([Catzc.Base.ModuleSystem.DiskModule]::new($name, "automation/$name", $isHidden, $packages))
        }
    }

    # ---- in-session: map every loaded module by its ModuleBase location (how it came into play) ----
    if ($Kind | Where-Object { $_ -in $sessionKinds }) {
        $automationFull = [System.IO.Path]::GetFullPath($modulesRoot)
        $vendorFull = [System.IO.Path]::GetFullPath((Join-Path $automationFull '.vendor'))
        $psHomeFull = if ($PSHOME) {
            [System.IO.Path]::GetFullPath($PSHOME)
        }
        else {
            $null
        }
        $ordinalCI = [System.StringComparison]::OrdinalIgnoreCase

        foreach ($module in Get-Module) {
            $moduleBase = "$($module.ModuleBase)"
            $provenance =
            if ($moduleBase -and $moduleBase.StartsWith($vendorFull, $ordinalCI)) {
                'vendored'
            }
            elseif ($moduleBase -and $moduleBase.StartsWith($automationFull, $ordinalCI)) {
                'imported'
            }
            elseif ($psHomeFull -and $moduleBase -and $moduleBase.StartsWith($psHomeFull, $ordinalCI)) {
                'builtin'
            }
            else {
                'residue'
            }
            if ($provenance -notin $Kind) {
                continue
            }
            $ret.Add([Catzc.Base.ModuleSystem.SessionModule]::new("$($module.Name)", $provenance, $moduleBase, "$($module.Version)"))
        }
    }

    [Catzc.Base.ModuleSystem.BaseModule[]] @($ret)
}
