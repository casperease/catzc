<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Git/Remove-RepositorySnapshot.ps1
    name: remove-repository-snapshot
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Git
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-git/Remove-RepositorySnapshot.ps1.md
    test: automation/Catzc.Base.Git/tests/Remove-RepositorySnapshot.Tests.ps1
    cites:
      - ADR-PWSH-ENUM#3
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
