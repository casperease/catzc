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
  config:
    synopsis: Returns the consumer overlay root Get-Config merges fragments from, cached per pair of session anchors.
    description: |-
      Get-Config sits on the hot path, so the overlay root (Get-CatzcOverlayRoot, which derives the run mode from the
      two roots) is worked out once per RepositoryRoot / CatzcModulesRoot pair and kept for the session
      ([ADR-PWSH-CACHE](/docs/adr/pwsh/script-scope-caching.md)). A change of either anchor — a new working root, or
      a switch of run mode — is a new key, so the answer never outlives the roots it came from.
    outputs: '[string] The overlay root, or nothing.'
---
#>

function Get-ConfigOverlayRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $anchors = "$(Get-RepositoryRoot)|$(Get-CatzcModulesRoot)"
    # strict-clean probe of the lazy cache entry
    # [comment:3](/docs/references/automation/catzc-base-config/private/Get-ConfigOverlayRoot.ps1.md#comment3)
    if ($ExecutionContext.SessionState.PSVariable.GetValue('script:configOverlayAnchors') -ne $anchors) {
        $script:configOverlayRoot = Get-CatzcOverlayRoot
        $script:configOverlayAnchors = $anchors
    }
    $script:configOverlayRoot
}
