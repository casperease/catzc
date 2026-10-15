<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Get-TrackedFile.ps1
    kind: function
    module: Catzc.Base.Globs
    visibility: public
---
#>

<#
.SYNOPSIS
    Returns every tracked file as a repo-relative, '/'-separated path — the globset matching universe.
.DESCRIPTION
    A tracked file deleted on disk is still listed; the hashing code folds a distinct missing marker for it.
    [ADR-AUTO-TRACKED#1](/docs/adr/automation/tracked-files-from-the-index.md#rule-adr-auto-tracked1),
    [ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)
    [comment:1](/docs/references/automation/catzc-base-globs/Get-TrackedFile.ps1.md#comment1)
.EXAMPLE
    Get-TrackedFile
#>
function Get-TrackedFile {
    param()
    Get-GitTrackedPath '.'
}
