---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/Publish-ContractRelease.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "4a5c3507f725"
    adrs:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Contracts/Publish-ContractRelease.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$files = [string[]] @(Get-ChildPath $draft -File -Depth 64 -Exclude @()...`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): the
freeze copies the whole draft, so no name is pruned and no depth drops a file.
```
