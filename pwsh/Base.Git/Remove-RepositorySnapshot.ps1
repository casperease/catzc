<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-git/Remove-RepositorySnapshot.ps1.md"
  header: "generated"
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
    if (-not [Catzc.Base.Git.GitWorkTree]::IsSnapshot($Path)) {
        throw "Refusing to delete '$Path': it is not a repository snapshot (no $([Catzc.Base.Git.GitWorkTree]::SnapshotMarkerFile) marker)."
    }

    try {
        [System.IO.Directory]::Delete($Path, $true)
    }
    catch [System.UnauthorizedAccessException] {
        # A named whole-tree walk: the read-only files are mostly git objects under .git, so nothing is pruned.
        foreach ($file in Get-ChildPath $Path -File -Depth 64 -Exclude @() -PruneVendor $false) {
            [System.IO.File]::SetAttributes($file, [System.IO.FileAttributes]::Normal)
        }
        [System.IO.Directory]::Delete($Path, $true)
    }
}
