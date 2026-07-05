<#
.SYNOPSIS
    Drops every recorded glob protection, forcing the next run of every protected scan to scan in full.
.DESCRIPTION
    The escape hatch for the protected-glob gate (ADR-PROTGLOB): the protection map is session memory, so
    an importer reload clears it anyway — this clears it without reloading. Use it when a full local rescan
    is wanted despite unchanged globsets (e.g. after changing the scan tool itself).
.EXAMPLE
    Clear-GlobSetProtection
#>
function Clear-GlobSetProtection {
    [CmdletBinding()]
    param()

    $script:protectedGlobSets = @{}
    $script:pendingGlobProtections = @{}
}
