<#
.SYNOPSIS
    Plans copying an extracted package tree into a destination tree without touching a file the destination already has.
.DESCRIPTION
    Compares the files and folders under -Source with -Destination and returns paths relative to both roots, with
    forward slashes:

      Directories  the folders the destination lacks, parents before children, so creating them in order works;
      Files        the files the destination lacks: the ones a copy adds, and the only ones an uninstall may delete;
      Kept         the files the destination already has: they belong to whoever placed them, so a copy leaves them alone.

    Reads the filesystem only and changes nothing, so the plan can be recorded before the copy starts and an
    interrupted copy is still covered by it
    ([ADR-AUTO-REMOVE#2](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove2)).
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

    $sourceDirectories = [System.Collections.Generic.List[string]]::new()
    foreach ($directory in [System.IO.Directory]::EnumerateDirectories($sourceRoot, '*', [System.IO.SearchOption]::AllDirectories)) {
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
    foreach ($file in [System.IO.Directory]::EnumerateFiles($sourceRoot, '*', [System.IO.SearchOption]::AllDirectories)) {
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
