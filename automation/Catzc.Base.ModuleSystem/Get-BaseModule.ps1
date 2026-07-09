<#
.SYNOPSIS
    Returns the automation modules as typed BaseModule objects, by kind — the native domain model (ADR-AUTO-TYPES:9).
.DESCRIPTION
    The typed view of the module system. Two facets, six kinds:

      on-disk (folders under automation/, returned as DiskModule with the folder's repo-relative path and the
      named packages it owns from configs/files.yml):
        'named'    a non-dot automation/* folder (Catzc.*)
        'hidden'   a dot-prefixed folder (.internal, .vendor, .compiled, .scriptanalyzer)

      in-session (every module loaded in the session, mapped by HOW IT CAME INTO PLAY — its ModuleBase
      location — returned as SessionModule with ModuleBase + Version):
        'imported' our automation module   — ModuleBase under automation/ (not .vendor)
        'vendored' our vendored third-party — ModuleBase under automation/.vendor/
        'builtin'  shipped with PowerShell  — ModuleBase under $PSHOME
        'residue'  genuinely foreign        — anything else (user profile, PowerShell Gallery, manual import)

    Default returns the on-disk kinds (named + hidden). Copy-Automation and the module completers act on those;
    the session kinds map what is loaded and where it came from (diagnostics, collision reporting).
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
    $repositoryRoot = Get-RepositoryRoot

    # ---- on-disk: named + hidden folders under automation/, with their files.yml packages ----
    if ($Kind | Where-Object { $_ -in $diskKinds }) {
        $bindings = (Get-Config -Config files).modules
        $automationRoot = Join-Path $repositoryRoot 'automation'

        # Ordinal sort for a deterministic, culture-independent order (cross-platform).
        $names = [string[]] @(
            [System.IO.Directory]::EnumerateDirectories($automationRoot) |
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
            if ($bindings -and $bindings.Contains($name) -and $bindings[$name].Contains('packages')) {
                $packageMap = $bindings[$name]['packages']
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
        $automationFull = [System.IO.Path]::GetFullPath((Join-Path $repositoryRoot 'automation'))
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
