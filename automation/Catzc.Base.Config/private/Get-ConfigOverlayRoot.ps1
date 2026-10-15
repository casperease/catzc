<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Config/private/Get-ConfigOverlayRoot.ps1
    kind: private-function
    module: Catzc.Base.Config
    visibility: private
    adrs:
      - ADR-PWSH-CACHE
      - ADR-PWSH-CACHE#4
---
#>

<#
.SYNOPSIS
    Returns the consumer overlay root Get-Config merges fragments from, cached per pair of session anchors.
.DESCRIPTION
    A change of either anchor is a new cache key, so the answer never outlives the roots it came from.
.OUTPUTS
    [string] The overlay root, or nothing.
#>
function Get-ConfigOverlayRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $anchors = "$(Get-RepositoryRoot)|$(Get-CatzcModulesRoot)"
    # Probe through session state, not the bare variable, so strict mode does not throw before the first load.
    # [comment:2](/docs/references/automation/catzc-base-config/private/Get-ConfigOverlayRoot.ps1.md#comment2)
    if ($ExecutionContext.SessionState.PSVariable.GetValue('script:configOverlayAnchors') -ne $anchors) {
        $script:configOverlayRoot = Get-CatzcOverlayRoot
        $script:configOverlayAnchors = $anchors
    }
    $script:configOverlayRoot
}
