---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/private/Get-ContractVersionAsset.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "28a999aad2ef"
    adrs:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Contracts/private/Get-ContractVersionAsset.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$files = [string[]] @(Get-ChildPath $moduleFolder -File -Depth 64 -Exclude...`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): every
asset of the version is listed, so no name is pruned and no depth drops one.
```
