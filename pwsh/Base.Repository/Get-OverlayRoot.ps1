function Get-OverlayRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if ((Get-CatzcRunMode) -ne 'build') {
        return
    }
    if (-not $env:CatzcModulesFolder) {
        throw 'Get-OverlayRoot: $env:CatzcModulesFolder is not set; the importer (importer.ps1) publishes it on every import.'
    }
    $overlayRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-RepositoryRoot) ".catzc/$env:CatzcModulesFolder"))
    if ([System.IO.Directory]::Exists($overlayRoot)) {
        $overlayRoot
    }
}
