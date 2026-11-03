function Get-ConfigOverlayRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $anchors = "$(Get-RepositoryRoot)|$(Get-CatzcModulesRoot)"
    # Probed through the variable table, so a first call under strict mode finds no cache instead of throwing.
    if ($ExecutionContext.SessionState.PSVariable.GetValue('script:configOverlayAnchors') -ne $anchors) {
        $script:configOverlayRoot = if ((Get-CatzcRunMode) -eq 'build') {
            # A build reads the consumer's overlay, which may also hold function and asset overrides.
            Get-OverlayRoot
        }
        else {
            # A source run reads only this repository's own fragments, so a consumer's overlay never leaks into the source tree.
            if (-not $env:CatzcModulesFolder) {
                throw 'Get-ConfigOverlayRoot: $env:CatzcModulesFolder is not set; the importer (importer.ps1) publishes it on every import.'
            }
            $fragmentRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-RepositoryRoot) ".catzc/$env:CatzcModulesFolder"))
            if ([System.IO.Directory]::Exists($fragmentRoot)) {
                $fragmentRoot
            }
        }
        $script:configOverlayAnchors = $anchors
    }
    $script:configOverlayRoot
}
