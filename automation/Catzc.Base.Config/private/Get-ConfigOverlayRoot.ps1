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
            # Source mode reads only this repository's own config fragments, under .catzc/<the modules folder>
            # ([ADR-CATS#5](/docs/adr/principles/cats-and-catzc.md#rule-adr-cats5)).
            $fragmentRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-RepositoryRoot) ".catzc/$(Split-Path -Leaf (Get-CatzcModulesRoot))"))
            if ([System.IO.Directory]::Exists($fragmentRoot)) {
                $fragmentRoot
            }
        }
        $script:configOverlayAnchors = $anchors
    }
    $script:configOverlayRoot
}
