<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Globs/Get-TrackedFile.ps1
    name: get-tracked-file
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
    cites:
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
