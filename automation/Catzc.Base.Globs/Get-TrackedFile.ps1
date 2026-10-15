<#
.SYNOPSIS
    Returns every tracked file as a repo-relative, '/'-separated path — the globset matching universe.
.DESCRIPTION
    `git ls-files` defines "files under version control": deterministic on every checkout, independent of build...
    [ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4),
    [ADR-AUTO-TRACKED#1](/docs/adr/automation/tracked-files-from-the-index.md#rule-adr-auto-tracked1)
    [comment:1](/docs/references/automation/catzc-base-globs/Get-TrackedFile.ps1.md#comment1)
.EXAMPLE
    Get-TrackedFile
#>
function Get-TrackedFile {
    param()
    Get-GitTrackedPath '.'
}
