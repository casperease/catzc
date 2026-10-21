<#
---
catzc:
  immutable:
    with_body_sha: abf588f2fd19
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
