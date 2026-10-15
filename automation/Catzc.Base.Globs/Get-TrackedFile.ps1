<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Get-TrackedFile.ps1
    kind: automation-function
    module: Catzc.Base.Globs
    visibility: public
    relatives:
      test: automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
    adrs:
      - ADR-AUTO-TRACKED#1
      - ADR-FLOW-CD-GLOBS#4
  config:
    synopsis: Returns every tracked file as a repo-relative, '/'-separated path — the globset matching universe.
    description: |-
      `git ls-files` defines "files under version control"
      ([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)): deterministic on every
      checkout, independent of build residue, blind to untracked and
      ignored files. Read through Get-GitTrackedPath, the one place that answers it (from the index, in-process —
      [ADR-AUTO-TRACKED#1](/docs/adr/automation/tracked-files-from-the-index.md#rule-adr-auto-tracked1)).
      A tracked file may be missing on disk (an unstaged deletion) — it is still listed here; the hashing code
      folds a distinct marker for it.
    examples:
      - Get-TrackedFile
---
#>

function Get-TrackedFile {
    param()
    Get-GitTrackedPath '.'
}
