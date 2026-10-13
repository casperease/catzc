<#
.SYNOPSIS
    Deletes a repository snapshot made by New-RepositorySnapshot.
.DESCRIPTION
    Removes the snapshot folder in one [System.IO.Directory]::Delete call, not item by item. It refuses any
    folder that does not carry New-RepositorySnapshot's provenance marker (.git/catzc-snapshot.json), so a
    wrong path can never delete a real checkout. Read-only files (git writes some) are made writable and the
    delete is retried once. A path that no longer exists is a no-op.
.PARAMETER Path
    The snapshot folder (the Path of New-RepositorySnapshot's result).
.OUTPUTS
    None.
.EXAMPLE
    Remove-RepositorySnapshot $snapshot.Path
#>
function Remove-RepositorySnapshot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    $Path = [System.IO.Path]::GetFullPath($Path)
    if (-not [System.IO.Directory]::Exists($Path)) {
        return
    }
    if (-not [System.IO.File]::Exists((Join-Path $Path '.git/catzc-snapshot.json'))) {
        throw "Refusing to delete '$Path': it is not a repository snapshot (no .git/catzc-snapshot.json marker)."
    }

    try {
        [System.IO.Directory]::Delete($Path, $true)
    }
    catch [System.UnauthorizedAccessException] {
        foreach ($file in [System.IO.Directory]::EnumerateFiles($Path, '*', [System.IO.SearchOption]::AllDirectories)) {
            [System.IO.File]::SetAttributes($file, [System.IO.FileAttributes]::Normal)
        }
        [System.IO.Directory]::Delete($Path, $true)
    }
}
