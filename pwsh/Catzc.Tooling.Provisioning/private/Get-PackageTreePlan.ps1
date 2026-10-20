<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Provisioning/private/Get-PackageTreePlan.ps1
    folder: private
    name: get-package-tree-plan
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Provisioning
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Tooling.Provisioning/tests/Get-PackageTreePlan.Tests.ps1
    docs: "[Get-PackageTreePlan.ps1.md](docs/references/pwsh/catzc-tooling-provisioning/private/Get-PackageTreePlan.ps1.md)"
    cites:
      - ADR-AUTO-REMOVE-UNINSTALLMANAGEDONLY
      - ADR-PWSH-ENUM-ALWAYSBOUNDED
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
