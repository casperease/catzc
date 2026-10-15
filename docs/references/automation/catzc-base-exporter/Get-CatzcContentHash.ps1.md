---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/Get-CatzcContentHash.ps1.md
    kind: comment-page
    body_sha: "9b4bcd979a7a"
    adrs:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$files = Get-ChildPath $rootFull -File -Depth 64 -Exclude @() -PruneVendor...`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): the hash
covers every file, so nothing is pruned and no depth drops one.
```
