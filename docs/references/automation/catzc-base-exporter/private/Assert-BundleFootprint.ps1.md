---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md
    kind: comment-page
    body_sha: "6dc0e05d2e95"
    adrs:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:2

Above `foreach ($file in Get-ChildPath $root -File -Depth 64 -Exclude @()...`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): the
footprint counts every shipped byte, so nothing is pruned.
```
