<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-config/private/Get-ConfigOverlayRoot.ps1.md"
  header: "generated"
---
#>

function Get-ConfigOverlayRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $anchors = "$(Get-RepositoryRoot)|$(Get-CatzcModulesRoot)"
    # Probed through the variable table, so a first call under strict mode finds no cache instead of throwing.
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
