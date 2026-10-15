<#
.SYNOPSIS
    Drops every recorded glob protection, forcing the next run of every protected scan to scan in full.
.DESCRIPTION
    The escape hatch for the protected-glob skip: the protection map is session memory, so an importer reload clears...
    [ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)
    [comment:1](/docs/references/automation/catzc-base-globs/Clear-GlobSetProtection.ps1.md#comment1)
.EXAMPLE
    Clear-GlobSetProtection
#>
function Clear-GlobSetProtection {
    [CmdletBinding()]
    param()

    $script:protectedGlobSets = @{}
    $script:pendingGlobProtections = @{}
}
