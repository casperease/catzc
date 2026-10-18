---
catzc:
  immutable:
    with_body_sha: "1b5a69f455e3"
    repo_status: locked
    path: docs/references/automation/catzc-base-contracts/types/ContractParameter.cs.md
    folder: docs/references/automation/catzc-base-contracts/types
    name: contract-parameter-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-REPO-CMDCONTRACT#2
---

# automation/Catzc.Base.Contracts/types/ContractParameter.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `private static readonly Regex SpecRe = new Regex(`, written with `//`.

```text
spec = type [ "!" ] [ "=" literal ] [ "pipeline" ]; type = base [ "[]" ]
([ADR-REPO-CMDCONTRACT#2](/docs/adr/repository/command-contracts.md#rule-adr-repo-cmdcontract2)).
```
