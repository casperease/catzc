<#
.SYNOPSIS
    Returns the consumer overlay root Get-Config merges fragments from, cached per pair of session anchors.
.DESCRIPTION
    Get-Config sits on the hot path, so the overlay root (Get-CatzcOverlayRoot, which derives the run mode from the...
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
    # strict-clean probe of the lazy cache entry
    # [ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4)
    # [comment:2](/docs/references/automation/catzc-base-config/private/Get-ConfigOverlayRoot.ps1.md#comment2)
    if ($ExecutionContext.SessionState.PSVariable.GetValue('script:configOverlayAnchors') -ne $anchors) {
        $script:configOverlayRoot = Get-CatzcOverlayRoot
        $script:configOverlayAnchors = $anchors
    }
    $script:configOverlayRoot
}
