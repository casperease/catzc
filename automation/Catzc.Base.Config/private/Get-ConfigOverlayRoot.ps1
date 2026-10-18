<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Config/private/Get-ConfigOverlayRoot.ps1
    folder: private
    name: get-config-overlay-root
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Config
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-config/private/Get-ConfigOverlayRoot.ps1.md
    test: automation/Catzc.Base.Config/tests/Get-ConfigOverlayRoot.Tests.ps1
    cites:
      - ADR-PWSH-CACHE
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
