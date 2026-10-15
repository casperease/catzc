---
catzc:
  derived:
    path: docs/references/automation/catzc-base-objects/ConvertTo-YamlSafe.ps1.md
    kind: reference
    body_sha: "3481d59bf203"
    adrs: []
---

# automation/Catzc.Base.Objects/ConvertTo-YamlSafe.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Used by Write-Object to produce clean YAML output for nested objects.
Walks PSCustomObject, IDictionary, and IEnumerable types, converting
each level into ordered hashtables or arrays that ConvertTo-Yaml can
serialize without falling back to ToString().
```
