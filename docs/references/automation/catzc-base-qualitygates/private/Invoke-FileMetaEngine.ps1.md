---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Invoke-FileMetaEngine.ps1.md
    kind: reference
    body_sha: b75338f1f4ae
    adrs:
      - ADR-REPO-FILEMETA#5
---

# docs/references/automation/catzc-base-qualitygates/private/Invoke-FileMetaEngine.ps1.md

`automation/Catzc.Base.QualityGates/private/Invoke-FileMetaEngine.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Each file's `derived` part is rebuilt from the imprint kinds of the registry, and its authored `config` part is kept as written.
A file whose block holds a key no kind owns is reported as Unowned and left unchanged, since writing it would drop the author's key
([ADR-REPO-FILEMETA#5](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta5)).
```
