<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Git/Remove-RepositorySnapshot.ps1
    name: remove-repository-snapshot
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Git
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Git/tests/Remove-RepositorySnapshot.Tests.ps1
    docs: "[Remove-RepositorySnapshot.ps1.md](docs/references/pwsh/catzc-base-git/Remove-RepositorySnapshot.ps1.md)"
    cites:
      - ADR-PWSH-ENUM-ALWAYSBOUNDED
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
        foreach ($file in Get-ChildPath $Path -File -Depth 64 -Exclude @() -PruneVendor $false) {
            [System.IO.File]::SetAttributes($file, [System.IO.FileAttributes]::Normal)
        }
        [System.IO.Directory]::Delete($Path, $true)
    }
}
