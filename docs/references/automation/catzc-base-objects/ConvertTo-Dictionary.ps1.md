---
catzc:
  derived:
    path: docs/references/automation/catzc-base-objects/ConvertTo-Dictionary.ps1.md
    kind: comment-page
    body_sha: e73f849c3c8e
---

# automation/Catzc.Base.Objects/ConvertTo-Dictionary.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$dict = ConvertTo-YamlSafe -Value $InputObject -MaxDepth $MaxDepth`.

```text
ConvertTo-YamlSafe is the shared recursive reflector — it already turns any object (typed class,
PSCustomObject, dictionary, array) into nested ordered dicts / arrays / scalars via
PSObject.Properties. We reuse it for the dictionary form, then optionally re-shape to PSCustomObjects.
```
