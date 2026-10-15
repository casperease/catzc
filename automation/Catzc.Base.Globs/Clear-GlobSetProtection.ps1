<#
.SYNOPSIS
    Drops every recorded glob protection, forcing the next run of every protected scan to scan in full.
.DESCRIPTION
    Use it for a full rescan when only the scan tool changed: unchanged globsets would otherwise keep skipping.
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
