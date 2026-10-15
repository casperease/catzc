---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Get-ManagedGuids.ps1.md
    kind: comment-page
    body_sha: "4e05573019be"
    adrs: []
---

# automation/Catzc.Base.QualityGates/Get-ManagedGuids.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Thin accessor over Get-Config -Config guids (mapped and validated by the GuidsConfig type on load,
session-cached). The returned map is read-only. Each entry is name -> ManagedGuidEntry
{ guid, description [, sentence] }; `sentence` is set when the GUID was minted from a sentence with
ConvertTo-Guid.
```
