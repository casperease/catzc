---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/Reset-GitCleanFxd.ps1.md
    kind: comment-page
    body_sha: "126d0e187858"
    adrs:
      - ADR-AUTO-DRYRUN#2
---

# automation/Catzc.Base.Git/Reset-GitCleanFxd.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `function Reset-GitCleanFxd {`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```

## comment:5

Above `$listing = Invoke-Executable 'git clean -xdn' -PassThru -Silent`.

```text
git's own dry run is the source of the candidates: exactly what `git clean -fxd` would remove, no
re-implementation of ignore semantics.
```
