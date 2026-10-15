<#
.SYNOPSIS
    Lists the repository-relative files the link engine reads.
.DESCRIPTION
    With no -Path, every git-tracked file (Get-GitTrackedPath) — the repository as committed, not whatever lies...
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-LinkScope.ps1.md#comment1)
.PARAMETER RepositoryRoot
    The repository root the returned paths are relative to.
.PARAMETER Path
    Optional files or folders (absolute or relative to the current location) to limit the scope to.
.OUTPUTS
    [string[]] repository-relative, '/'-separated paths.
#>
function Get-LinkScope {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path
    )

    # Never enumerate a whole drive: neither the repository root nor a -Path may be a disk root (C:\, /, a UNC share...
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-LinkScope.ps1.md#comment2)
    $isDiskRoot = {
        param([string] $FullPath)
        $FullPath.TrimEnd('\', '/') -eq ([System.IO.Path]::GetPathRoot($FullPath)).TrimEnd('\', '/')
    }

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    Assert-False (& $isDiskRoot $root) -ErrorText "Get-LinkScope: the repository root '$root' is a disk root — refusing to scan a whole drive."
    $files = if ($Path) {
        foreach ($item in $Path) {
            $full = [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $item).Path)
            Assert-False (& $isDiskRoot $full) -ErrorText "Get-LinkScope: -Path '$item' resolves to the disk root '$full' — refusing to scan a whole drive."
            $found = if (Test-Path -LiteralPath $full -PathType Container) {
                [System.IO.Directory]::EnumerateFiles($full, '*', [System.IO.SearchOption]::AllDirectories)
            }
            else {
                $full
            }
            foreach ($file in $found) {
                [System.IO.Path]::GetRelativePath($root, $file) -replace '\\', '/'
            }
        }
    }
    else {
        Get-GitTrackedPath '.'
    }

    $inRepository = @($files | Where-Object { $_ -notmatch '^\.\./' })
    # Get-ContentExemptPath returns its paths as one array: assign it, so the set holds the paths, not the array.
    $exemptPaths = Get-ContentExemptPath -RepositoryRoot $root -Path $inRepository
    $exempt = [System.Collections.Generic.HashSet[string]]::new([string[]] @($exemptPaths))
    @($inRepository | Where-Object { -not $exempt.Contains($_) })
}
