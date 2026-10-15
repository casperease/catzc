---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Get-ContractDotFolderFindings.ps1.md
    kind: comment-page
    body_sha: "6a72ffb45cde"
    adrs:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:2

Above `$folders = [string[]] @(Get-ChildPath $contractsRoot -Directory -Depth 64...`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): this gate
looks for stray folders, so no name is pruned and no depth hides one.
```
