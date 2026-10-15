<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Get-TrackedFile.ps1
    kind: function
    module: Catzc.Base.Globs
    visibility: public
    adrs:
      - ADR-AUTO-TRACKED#1
      - ADR-FLOW-CD-GLOBS#4
---
#>

<#
.SYNOPSIS
    Returns every tracked file as a repo-relative, '/'-separated path — the globset matching universe.
.DESCRIPTION
    A tracked file deleted on disk is still listed; the hashing code folds a distinct missing marker for it.
.EXAMPLE
    Get-TrackedFile
#>
function Get-TrackedFile {
    param()
    Get-GitTrackedPath '.'
}
