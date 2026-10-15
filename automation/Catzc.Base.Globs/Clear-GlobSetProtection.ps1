<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Clear-GlobSetProtection.ps1
    kind: public-function
    module: Catzc.Base.Globs
    visibility: public
    adrs:
      - ADR-REPO-PROTGLOB
---
#>

<#
.SYNOPSIS
    Drops every recorded glob protection, forcing the next run of every protected scan to scan in full.
.DESCRIPTION
    Use it for a full rescan when only the scan tool changed: unchanged globsets would otherwise keep skipping.
.EXAMPLE
    Clear-GlobSetProtection
#>
function Clear-GlobSetProtection {
    [CmdletBinding()]
    param()

    $script:protectedGlobSets = @{}
    $script:pendingGlobProtections = @{}
}
