---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/configs/file-meta.yml.md
    kind: comment-page
    body_sha: aebb70fa394b
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-REPO-COMMENTS#3
      - ADR-REPO-FILEMETA#2
    links: []
---

# automation/Catzc.Base.QualityGates/configs/file-meta.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `kinds:`.

```text
The meta-kind registry: each entry is one kind of derived fact imprinted into a file's meta block, with defaults on FileMetaKind.
[ADR-REPO-FILEMETA#2](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta2),
[ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)
```

## comment:2

Above `- {`.

```text
A comment page keeps its source file's name and extension plus .md
([ADR-REPO-COMMENTS#3](/docs/adr/repository/comments-in-docs.md#rule-adr-repo-comments3)), so the name marks it; it wins over
reference.
```

## comment:3

Above `adr-codes:`.

```text
The ADR codes the file cites, its comment page's too, sorted and without duplicates, less the rules it defines; a long key, so late.
A code file also lists the bare domain codes.
```
