---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/types/CarrierKind.cs.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: d531d05fa3d2
    adrs:
      - ADR-REPO-FILEMETA#1
---

# automation/Catzc.Base.Languages/types/CarrierKind.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.Languages;`, written with `//`.

```text
Where a file keeps its meta block: in its own text (front matter, comment head, ignored property), beside it (sidecar), or nowhere.
[ADR-REPO-FILEMETA#1](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta1)
```
