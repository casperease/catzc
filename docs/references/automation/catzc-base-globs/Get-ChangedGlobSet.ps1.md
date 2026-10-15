---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/Get-ChangedGlobSet.ps1.md
    kind: comment-page
    body_sha: "92502435284b"
    adrs:
      - ADR-FLOW-CD-GLOBS#4
---

# automation/Catzc.Base.Globs/Get-ChangedGlobSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reflects a change into the globset registry: returns every declared globset whose scan program
(GlobSet.Matches, last-match-wins
[ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)) selects at least one changed
path. The "which areas of
control did this change touch" fact, computed from git at the real refs — reading the merged tree as it
actually is, so it is immune to the squash-merge and concurrent-merge staleness a per-set hash frozen on a
branch would suffer, and correct across renames (Get-ChangedFile splits a rename into both of its paths).

The changed paths come either explicitly (-ChangedFile, a pure and testable call) or from a git range
(-Range) resolved through Get-ChangedFile. -IncludeModules also matches the derived per-module sets
(Get-ModuleGlobSet), so a report can name the changed modules, not only the declared units.

In a pipeline this is the "is there anything here for us to process?" gate: a deployable unit's stage asks
whether its own set is in the returned list and stops early when it is not. The reference commit that
range is measured from is the resolver's job, never this function's.
```
