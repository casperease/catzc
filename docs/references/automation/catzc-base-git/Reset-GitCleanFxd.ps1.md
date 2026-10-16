---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/Reset-GitCleanFxd.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "467486aa6d9a"
    adrs:
      - ADR-AUTO-DRYRUN#2
---

# automation/Catzc.Base.Git/Reset-GitCleanFxd.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Reset-GitCleanFxd {`, written with `#`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```

## comment:2

Above `$listing = Invoke-Executable 'git clean -xdn' -PassThru -Silent`, written with `#`.

```text
git's own dry run is the source of the candidates: exactly what `git clean -fxd` would remove, no
re-implementation of ignore semantics.
```
