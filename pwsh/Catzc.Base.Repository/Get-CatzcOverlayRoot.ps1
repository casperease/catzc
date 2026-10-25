<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-repository/Get-CatzcOverlayRoot.ps1.md"
  header: "generated"
---
#>

function Get-CatzcOverlayRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if ((Get-CatzcRunMode) -ne 'build') {
        return
    }
    $overlayRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-RepositoryRoot) '.catzc/pwsh'))
    if ([System.IO.Directory]::Exists($overlayRoot)) {
        $overlayRoot
    }
}
