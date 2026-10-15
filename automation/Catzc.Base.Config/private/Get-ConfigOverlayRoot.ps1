<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Config/private/Get-ConfigOverlayRoot.ps1
    kind: function
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
    [ADR-PWSH-CACHE](/docs/adr/pwsh/script-scope-caching.md)
    [comment:1](/docs/references/automation/catzc-base-config/private/Get-ConfigOverlayRoot.ps1.md#comment1)
.OUTPUTS
    [string] The overlay root, or nothing.
#>
function Get-ConfigOverlayRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $anchors = "$(Get-RepositoryRoot)|$(Get-CatzcModulesRoot)"
    # Probe through session state, not the bare variable, so strict mode does not throw before the first load.
    # [ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4)
    # [comment:2](/docs/references/automation/catzc-base-config/private/Get-ConfigOverlayRoot.ps1.md#comment2)
    if ($ExecutionContext.SessionState.PSVariable.GetValue('script:configOverlayAnchors') -ne $anchors) {
        $script:configOverlayRoot = Get-CatzcOverlayRoot
        $script:configOverlayAnchors = $anchors
    }
    $script:configOverlayRoot
}
