---
catzc:
  derived:
    path: docs/references/automation/catzc-base-overlay/private/Get-LocalModuleViolation.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "6d5a92f076c4"
    adrs:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Overlay/private/Get-LocalModuleViolation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$files = [string[]] @(Get-ChildPath $Path -File -Depth 64 -Exclude @()...`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): a
violation anywhere in the module must show, so nothing is pruned.
```
