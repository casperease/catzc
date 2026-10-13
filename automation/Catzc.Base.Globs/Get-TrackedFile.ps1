<#
.SYNOPSIS
    Returns every tracked file as a repo-relative, '/'-separated path — the globset matching universe.
.DESCRIPTION
    `git ls-files` defines "files under version control"
    ([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)): deterministic on every
    checkout, independent of build residue, blind to untracked and
    ignored files. Read through Get-GitTrackedPath, the one place that answers it (from the index, in-process —
    [ADR-AUTO-TRACKED#1](/docs/adr/automation/tracked-files-from-the-index.md#rule-adr-auto-tracked1)).
    A tracked file may be missing on disk (an unstaged deletion) — it is still listed here; the hash layer
    folds a distinct marker for it.
.EXAMPLE
    Get-TrackedFile
#>
function Get-TrackedFile {
    param()
    Get-GitTrackedPath '.'
}
