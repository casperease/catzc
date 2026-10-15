---
catzc:
  derived:
    path: docs/references/automation/catzc-base-writers/Write-Object.ps1.md
    kind: reference
    body_sha: d05ebe6233da
    adrs: []
---

# automation/Catzc.Base.Writers/Write-Object.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Renders objects differently based on their type:
- Simple values (string, number, bool): displayed directly
- Hashtables and ordered dictionaries: key = value pairs
- Collections/arrays: listed as items, or YAML if elements are complex
- PSCustomObject and other complex types: YAML
First line always shows the type name and size where relevant.

Suppressed during Pester test runs (like Write-Message) to keep test output clean.
```
