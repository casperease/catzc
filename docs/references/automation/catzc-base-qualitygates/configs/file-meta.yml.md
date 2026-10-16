---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/configs/file-meta.yml.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "73b526bcb523"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-REPO-COMMENTS#3
      - ADR-REPO-FILEMETA#2
---

# automation/Catzc.Base.QualityGates/configs/file-meta.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `kinds:`, written with `#`.

```text
The meta-kind registry: each entry is one kind of derived fact imprinted into a file's meta block, with defaults on FileMetaKind.
[ADR-REPO-FILEMETA#2](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta2),
[ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)
```

## comment:2

Above `- {` (occurrence 2), written with `#`.

```text
A comment page keeps its source file's name and extension plus .md
([ADR-REPO-COMMENTS#3](/docs/adr/repository/comments-in-docs.md#rule-adr-repo-comments3)), so the name marks it; it wins over
reference.
```

## comment:3

Above `adr-codes:`, written with `#`.

```text
The ADR codes the file cites, its comment page's too, sorted and without duplicates, less the rules it defines; a long key, so late.
A code file also lists the bare domain codes.
```
