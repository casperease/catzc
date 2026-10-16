---
catzc:
  immutable:
    with_body_sha: a6fb6e2726f3
    repo_status: locked
    path: docs/references/automation/catzc-base-modulesystem/Copy-Automation.ps1.md
    folder: docs/references/automation/catzc-base-modulesystem
    name: copy-automation-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-ENUM#{1,3}
---

# automation/Catzc.Base.ModuleSystem/Copy-Automation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ([System.IO.Directory]::Exists($destinationRoot) -and...`, written with `#`.

```text
An emptiness probe stops at the first entry of any kind, hidden and pruned names included
([ADR-PWSH-ENUM#1](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum1)).
```

## comment:2

Above `foreach ($file in Get-ChildPath $item.Source -File -Depth 64 -Exclude @()...`, written with `#`.

```text
A named whole-tree walk
([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): every file the
copy would write is checked for a conflict.
```
