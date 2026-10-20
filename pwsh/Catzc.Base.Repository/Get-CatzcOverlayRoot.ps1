<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Repository/Get-CatzcOverlayRoot.ps1
    name: get-catzc-overlay-root
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Repository
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Repository/tests/Get-CatzcOverlayRoot.Tests.ps1
    docs: "[Get-CatzcOverlayRoot.ps1.md](docs/references/pwsh/catzc-base-repository/Get-CatzcOverlayRoot.ps1.md)"
    cites:
      - ADR-AUTO-OVERLAY
---
#>

function Get-CatzcOverlayRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if ((Get-CatzcRunMode) -ne 'build') {
        return
    }
    $overlayRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-RepositoryRoot) '.catzc/pwsh'))
    if ([System.IO.Directory]::Exists($overlayRoot)) {
        $overlayRoot
    }
}
