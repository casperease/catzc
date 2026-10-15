<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/private/Get-PackageTreePlan.ps1
    kind: function
    module: Catzc.Tooling.Provisioning
    visibility: private
    adrs:
      - ADR-AUTO-REMOVE#2
---
#>

<#
.SYNOPSIS
    Plans copying an extracted package tree into a destination tree without touching a file the destination already has.
.DESCRIPTION
    Read-only, so the plan can be recorded before the copy starts and an interrupted copy is still covered by it.
.PARAMETER Source
    The extracted package tree.
.PARAMETER Destination
    The tree the package is copied into.
.OUTPUTS
    [pscustomobject] { Directories; Files; Kept }
.EXAMPLE
    Get-PackageTreePlan -Source $staging -Destination $gitHome
#>
function Get-PackageTreePlan {
    [OutputType([pscustomobject])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Source,

        [Parameter(Mandatory)]
        [string] $Destination
    )

    $sourceRoot = [System.IO.Path]::GetFullPath($Source)
    $destinationRoot = [System.IO.Path]::GetFullPath($Destination)

    # A named whole-tree walk (ADR-PWSH-ENUM#3): a copy plan must see every file, so no folder name is pruned and the depth is the
    # config's ceiling. A real package tree reaches ten levels, and a shallower bound would silently drop files from the copy.
    $sourceDirectories = [System.Collections.Generic.List[string]]::new()
    foreach ($directory in Get-ChildPath $sourceRoot -Directory -Depth 64 -Exclude @() -PruneVendor $false) {
        $sourceDirectories.Add([System.IO.Path]::GetRelativePath($sourceRoot, $directory).Replace('\', '/'))
    }
    # A parent is a prefix of its children, so the ordinal order lists every parent first.
    $sourceDirectories.Sort([System.StringComparer]::Ordinal)

    $directories = [System.Collections.Generic.List[string]]::new()
    foreach ($relative in $sourceDirectories) {
        if (-not [System.IO.Directory]::Exists((Join-Path $destinationRoot $relative))) {
            $directories.Add($relative)
        }
    }

    $files = [System.Collections.Generic.List[string]]::new()
    $kept = [System.Collections.Generic.List[string]]::new()
    foreach ($file in Get-ChildPath $sourceRoot -File -Depth 64 -Exclude @() -PruneVendor $false) {
        $relative = [System.IO.Path]::GetRelativePath($sourceRoot, $file).Replace('\', '/')
        if ([System.IO.File]::Exists((Join-Path $destinationRoot $relative))) {
            $kept.Add($relative)
        }
        else {
            $files.Add($relative)
        }
    }
    $files.Sort([System.StringComparer]::Ordinal)
    $kept.Sort([System.StringComparer]::Ordinal)

    [pscustomobject]@{
        Directories = $directories.ToArray()
        Files       = $files.ToArray()
        Kept        = $kept.ToArray()
    }
}
