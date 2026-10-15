---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/Publish-ContractRelease.ps1.md
    kind: comment-page
    body_sha: "4e9f78cc82a1"
    adrs:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:2

Above `$files = [string[]] @(Get-ChildPath $draft -File -Depth 64 -Exclude @()...`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): the
freeze copies the whole draft, so no name is pruned and no depth drops a file.
```
