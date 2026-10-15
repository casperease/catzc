<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/private/Get-PackageTreePlan.ps1
    kind: automation-function
    module: Catzc.Tooling.Provisioning
    visibility: private
    adrs:
      - ADR-AUTO-REMOVE#2
      - ADR-PWSH-ENUM#3
  config:
    synopsis: Plans copying an extracted package tree into a destination tree without touching a file the destination already has.
    description: |-
      Compares the files and folders under -Source with -Destination and returns paths relative to both roots, with
      forward slashes:

        Directories  the folders the destination lacks, parents before children, so creating them in order works;
        Files        the files the destination lacks: the ones a copy adds, and the only ones an uninstall may delete;
        Kept         the files the destination already has: they belong to whoever placed them, so a copy leaves them alone.

      Reads the filesystem only and changes nothing, so the plan can be recorded before the copy starts and an
      interrupted copy is still covered by it
      ([ADR-AUTO-REMOVE#2](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove2)).
    parameters:
      Source: The extracted package tree.
      Destination: The tree the package is copied into.
    outputs: '[pscustomobject] { Directories; Files; Kept }'
    examples:
      - Get-PackageTreePlan -Source $staging -Destination $gitHome
---
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

    # A named whole-tree walk: a copy plan must see every file, so no folder name is pruned and the depth is the...
    # [comment:2](/docs/references/automation/catzc-tooling-provisioning/private/Get-PackageTreePlan.ps1.md#comment2)
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
