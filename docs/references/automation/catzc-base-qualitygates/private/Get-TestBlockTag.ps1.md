---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestBlockTag.ps1.md
    kind: comment-page
    body_sha: "2c5261d8e641"
---

# automation/Catzc.Base.QualityGates/private/Get-TestBlockTag.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `foreach ($levelTags in $levels) {`.

```text
The nearest level carrying any tag of this axis wins; return its canonical matches ('-eq' is
case-insensitive). One match is the norm; two means an ambiguous block, surfaced as a violation upstream.
```
