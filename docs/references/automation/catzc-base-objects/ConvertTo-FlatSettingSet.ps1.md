---
catzc:
  derived:
    path: docs/references/automation/catzc-base-objects/ConvertTo-FlatSettingSet.ps1.md
    kind: comment-page
    body_sha: ea74072c2a74
    adrs: []
    links: []
---

# automation/Catzc.Base.Objects/ConvertTo-FlatSettingSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Recursively walks a PSCustomObject (e.g. parsed JSON/YAML configuration)
and returns an OrderedDictionary where each key is the full dot-separated
path to a leaf property and each value is the leaf value.

Non-leaf nodes (objects, dictionaries, arrays) are expanded, not included.
Null values are stored as empty strings.

Supports pipeline input for batch processing.
```
