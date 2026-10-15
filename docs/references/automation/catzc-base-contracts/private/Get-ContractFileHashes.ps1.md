---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Get-ContractFileHashes.ps1.md
    kind: comment-page
    body_sha: "9eea389a7658"
    adrs:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Contracts/private/Get-ContractFileHashes.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:2

Above `$files = [string[]] @(Get-ChildPath $Folder -File -Depth 64 -Exclude @()...`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): a frozen
contract is hashed in full, so no name is pruned and no depth drops a file.
```
