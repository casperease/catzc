---
catzc:
  immutable:
    with_body_sha: "6a4f057957d1"
    path: docs/references/automation/catzc-base-qualitygates/types/FileMetaDirection.cs.md
    folder: docs/references/automation/catzc-base-qualitygates/types
    name: file-meta-direction-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-REPO-FILEMETA#2
---

# automation/Catzc.Base.QualityGates/types/FileMetaDirection.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.QualityGates;`, written with `//`.

```text
Imprint writes derived facts into a file's meta block; gather reads config contributions out of it.
[ADR-REPO-FILEMETA#2](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta2)
```
