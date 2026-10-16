---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/types/FileCarriersConfig.cs.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "4c24139142ab"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-PRIN-CONFIG#1
      - ADR-REPO-FILEMETA#1
---

# automation/Catzc.Base.Languages/types/FileCarriersConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Every file class names where its meta block lives or why it has none, so a gap is a visible, reviewed entry.
[ADR-REPO-FILEMETA#1](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta1),
[ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1),
[ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)
```
