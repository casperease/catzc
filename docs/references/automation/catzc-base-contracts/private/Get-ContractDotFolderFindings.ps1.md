---
catzc:
  immutable:
    with_body_sha: "268c6162b3b9"
    path: docs/references/automation/catzc-base-contracts/private/Get-ContractDotFolderFindings.ps1.md
    folder: docs/references/automation/catzc-base-contracts/private
    name: get-contract-dot-folder-findings-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Contracts/private/Get-ContractDotFolderFindings.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$folders = [string[]] @(Get-ChildPath $contractsRoot -Directory -Depth 64...`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): this gate
looks for stray folders, so no name is pruned and no depth hides one.
```
