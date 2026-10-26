function Clear-GlobSetProtection {
    [CmdletBinding()]
    param()

    $script:protectedGlobSets = @{}
    $script:pendingGlobProtections = @{}
}
