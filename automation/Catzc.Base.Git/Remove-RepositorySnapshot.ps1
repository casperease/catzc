<#
.SYNOPSIS
    Deletes a repository snapshot made by New-RepositorySnapshot.
.DESCRIPTION
    Refuses any folder without New-RepositorySnapshot's marker, so a wrong path never deletes a real checkout.
    [comment:1](/docs/references/automation/catzc-base-git/Remove-RepositorySnapshot.ps1.md#comment1)
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
    if (-not (Test-RepositorySnapshot $Path)) {
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
