function Clear-StaleBuildFile {
    # .SYNOPSIS
    #     Deletes every file under the build root that the plan does not name, then every emptied folder.
    # .DESCRIPTION
    #     A file that cannot be deleted fails the build with its path, rather than leave a second types DLL.
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Mandatory)]
        [string] $BuildRoot,

        [Parameter(Mandatory)]
        [System.Collections.Generic.HashSet[string]] $KeepPath
    )

    $removed = 0
    if (-not [System.IO.Directory]::Exists($BuildRoot)) {
        return $removed
    }
    # A named whole-tree walk
    # ([ADR-PWSH-ENUM-ALWAYSBOUNDED](/docs/drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)): a stale
    # file anywhere under the build root must go, so nothing is pruned.
    foreach ($file in @(Get-ChildPath $BuildRoot -File -Depth 64 -Exclude @() -PruneVendor $false)) {
        $relativePath = [System.IO.Path]::GetRelativePath($BuildRoot, $file).Replace('\', '/')
        if (-not $KeepPath.Contains($relativePath)) {
            try {
                [System.IO.File]::Delete($file)
            }
            catch {
                throw "Invoke-ModuleBuild: cannot remove the stale build file '$file' ($($_.Exception.Message)). Close the session that loaded it, then rebuild."
            }
            $removed++
        }
    }
    # Deepest folders first, so a parent empties after its children.
    $folders = [string[]] @(Get-ChildPath $BuildRoot -Directory -Depth 64 -Exclude @() -PruneVendor $false)
    [System.Array]::Sort($folders, [System.Comparison[string]] { param($left,
        $right) $right.Length.CompareTo($left.Length) })
    foreach ($folder in $folders) {
        if (-not [System.IO.Directory]::EnumerateFileSystemEntries($folder).GetEnumerator().MoveNext()) {
            [System.IO.Directory]::Delete($folder)
        }
    }
    $removed
}
