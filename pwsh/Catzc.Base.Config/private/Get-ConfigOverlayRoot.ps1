<#
---
catzc:
  immutable:
    with_body_sha: "4c5450ff2f33"
  edges:
    test: pwsh/Catzc.Base.Config/tests/Get-ConfigOverlayRoot.Tests.ps1
    docs: "[Get-ConfigOverlayRoot.ps1.md](../../../docs/references/pwsh/catzc-base-config/private/Get-ConfigOverlayRoot.ps1.md)"
    cites:
      - ADR-PWSH-CACHE
      - PDR-CATS-FOLDERSUSECATZC
---
#>

function Get-ConfigOverlayRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $anchors = "$(Get-RepositoryRoot)|$(Get-CatzcModulesRoot)"
    if ($ExecutionContext.SessionState.PSVariable.GetValue('script:configOverlayAnchors') -ne $anchors) {
        $script:configOverlayRoot = if ((Get-CatzcRunMode) -eq 'build') {
            # A build reads the consumer's overlay, which may also hold function and asset overrides.
            Get-CatzcOverlayRoot
        }
        else {
            $fragmentRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-RepositoryRoot) ".catzc/$(Split-Path -Leaf (Get-CatzcModulesRoot))"))
            if ([System.IO.Directory]::Exists($fragmentRoot)) {
                $fragmentRoot
            }
        }
        $script:configOverlayAnchors = $anchors
    }
    $script:configOverlayRoot
}
