---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/configs/file-meta.yml.md
    kind: reference
    body_sha: "33bffd301d94"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-REPO-FILEMETA#2
---

# docs/references/automation/catzc-base-qualitygates/configs/file-meta.yml.md

`automation/Catzc.Base.QualityGates/configs/file-meta.yml`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `kinds:`.

```text
The meta-kind registry: each entry is one kind of derived fact imprinted into a file's meta block, with defaults on FileMetaKind.
[ADR-REPO-FILEMETA#2](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta2),
[ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)
```
