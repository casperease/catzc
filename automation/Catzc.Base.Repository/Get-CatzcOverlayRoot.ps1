<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Repository/Get-CatzcOverlayRoot.ps1
    kind: public-function
    module: Catzc.Base.Repository
    visibility: public
    adrs:
      - ADR-AUTO-OVERLAY
---
#>

<#
.SYNOPSIS
    Returns the consumer's overlay root — <RepositoryRoot>/.catzc/automation — or nothing when there is none.
.DESCRIPTION
    Build mode only: in source mode automation/ is edited directly, so a .catzc/ folder there is ignored.
.OUTPUTS
    [string] The full path of the overlay root, or nothing.
.EXAMPLE
    Get-CatzcOverlayRoot
#>
function Get-CatzcOverlayRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if ((Get-CatzcRunMode) -ne 'build') {
        return
    }
    $overlayRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-RepositoryRoot) '.catzc/automation'))
    if ([System.IO.Directory]::Exists($overlayRoot)) {
        $overlayRoot
    }
}
