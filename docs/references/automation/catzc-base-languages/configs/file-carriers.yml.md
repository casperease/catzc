---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/configs/file-carriers.yml.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "5511923651f8"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-PRIN-CONFIG#1
      - ADR-REPO-FILEMETA#1
---

# automation/Catzc.Base.Languages/configs/file-carriers.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `carriers:`, written with `#`.

```text
Where each file class keeps its meta block, or the reason it has none; a class with files: wins over a language of the same file.
[ADR-REPO-FILEMETA#1](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta1),
[ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1),
[ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)
```
