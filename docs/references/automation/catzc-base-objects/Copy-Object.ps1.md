---
catzc:
  derived:
    path: docs/references/automation/catzc-base-objects/Copy-Object.ps1.md
    kind: comment-page
    body_sha: d842c3c74be1
---

# automation/Catzc.Base.Objects/Copy-Object.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Recursively copies hashtables, ordered dictionaries, PSCustomObjects,
arrays, and lists. Value types and strings are returned as-is (immutable
or copied by value). Unknown reference types are returned by reference.

PSCustomObject cloning only copies NoteProperties. Use -AcceptWarnings
to suppress the warning about this limitation.

Does not use BinaryFormatter or any serialization-based approach.
```
