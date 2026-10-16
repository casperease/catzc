<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Config/private/Get-ConfigOverlayRoot.ps1
    kind: automation-function
    module: Catzc.Base.Config
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-config/private/Get-ConfigOverlayRoot.ps1.md
      test: automation/Catzc.Base.Config/tests/Get-ConfigOverlayRoot.Tests.ps1
    adrs:
      - ADR-PWSH-CACHE
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
    if ($ExecutionContext.SessionState.PSVariable.GetValue('script:configOverlayAnchors') -ne $anchors) {
        $script:configOverlayRoot = Get-CatzcOverlayRoot
        $script:configOverlayAnchors = $anchors
    }
    $script:configOverlayRoot
}
