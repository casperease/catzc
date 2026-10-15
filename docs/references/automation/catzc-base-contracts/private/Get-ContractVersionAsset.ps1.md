---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Get-ContractVersionAsset.ps1.md
    kind: comment-page
    body_sha: b304718d7dc1
    adrs:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Contracts/private/Get-ContractVersionAsset.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:2

Above `$files = [string[]] @(Get-ChildPath $moduleFolder -File -Depth 64 -Exclude...`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): every
asset of the version is listed, so no name is pruned and no depth drops one.
```
