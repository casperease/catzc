<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Git/Remove-RepositorySnapshot.ps1
    kind: automation-function
    module: Catzc.Base.Git
    visibility: public
    adrs:
      - ADR-PWSH-ENUM#3
  config:
    synopsis: Deletes a repository snapshot made by New-RepositorySnapshot.
    description: |-
      Removes the snapshot folder in one [System.IO.Directory]::Delete call, not item by item. It refuses any
      folder that does not carry New-RepositorySnapshot's provenance marker (.git/catzc-snapshot.json), so a
      wrong path can never delete a real checkout. Read-only files (git writes some) are made writable and the
      delete is retried once. A path that no longer exists is a no-op.
    parameters:
      Path: The snapshot folder (the Path of New-RepositorySnapshot's result).
    outputs: None.
    examples:
      - Remove-RepositorySnapshot $snapshot.Path
---
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
        # A named whole-tree walk: the read-only files are mostly git objects under.git, so nothing is pruned.
        # [comment:2](/docs/references/automation/catzc-base-git/Remove-RepositorySnapshot.ps1.md#comment2)
        foreach ($file in Get-ChildPath $Path -File -Depth 64 -Exclude @() -PruneVendor $false) {
            [System.IO.File]::SetAttributes($file, [System.IO.FileAttributes]::Normal)
        }
        [System.IO.Directory]::Delete($Path, $true)
    }
}
