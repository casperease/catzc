<#
.SYNOPSIS
    Returns the consumer's overlay root — <RepositoryRoot>/.catzc/automation — or nothing when there is none.
.DESCRIPTION
    A consumer of a built bundle works in its own working root and changes what the bundle does only through its...
    [ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)
    [comment:1](/docs/references/automation/catzc-base-repository/Get-CatzcOverlayRoot.ps1.md#comment1)
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
