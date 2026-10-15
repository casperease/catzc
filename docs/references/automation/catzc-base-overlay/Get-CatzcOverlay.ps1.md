---
catzc:
  derived:
    path: docs/references/automation/catzc-base-overlay/Get-CatzcOverlay.ps1.md
    kind: comment-page
    body_sha: "164f68a9cade"
    adrs:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Overlay/Get-CatzcOverlay.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$files = [string[]] @(Get-ChildPath $folder -File -Depth 64 -Exclude @()...`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): every
file of a consumer module is classified, so nothing is pruned.
```
