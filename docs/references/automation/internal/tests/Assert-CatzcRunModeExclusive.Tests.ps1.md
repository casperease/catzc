---
catzc:
  derived:
    path: docs/references/automation/internal/tests/Assert-CatzcRunModeExclusive.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e83f8ed9a3fd
---

# automation/.internal/tests/Assert-CatzcRunModeExclusive.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:packageRoot = Join-Path $TestDrive 'package'`, written with `#`.

```text
Two fixture code roots: an active one and another one, each holding catzc-named modules, plus a
non-catzc module and a package module 'Catzc' whose ModuleBase is the active root's parent.
```
