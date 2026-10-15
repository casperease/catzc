<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Git/Remove-RepositorySnapshot.ps1
    kind: public-function
    module: Catzc.Base.Git
    visibility: public
    adrs:
      - ADR-PWSH-ENUM#3
---
#>

<#
.SYNOPSIS
    Deletes a repository snapshot made by New-RepositorySnapshot.
.DESCRIPTION
    Refuses any folder without New-RepositorySnapshot's marker, so a wrong path never deletes a real checkout.
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
        # A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): the
        # read-only files are mostly git objects under .git, so nothing is pruned.
        foreach ($file in Get-ChildPath $Path -File -Depth 64 -Exclude @() -PruneVendor $false) {
            [System.IO.File]::SetAttributes($file, [System.IO.FileAttributes]::Normal)
        }
        [System.IO.Directory]::Delete($Path, $true)
    }
}
