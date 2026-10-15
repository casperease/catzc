---
catzc:
  derived:
    path: docs/references/automation/internal/tests/Assert-CatzcRunModeExclusive.Tests.ps1.md
    kind: test-asset
    body_sha: f1c50e8647a4
---

# automation/.internal/tests/Assert-CatzcRunModeExclusive.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:packageRoot = Join-Path $TestDrive 'package'`.

```text
Two fixture code roots: an active one and another one, each holding catzc-named modules, plus a
non-catzc module and a package module 'Catzc' whose ModuleBase is the active root's parent.
```
