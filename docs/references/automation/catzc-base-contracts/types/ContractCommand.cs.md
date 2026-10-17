---
catzc:
  immutable:
    with_body_sha: de2b4468a52e
    repo_status: locked
    path: docs/references/automation/catzc-base-contracts/types/ContractCommand.cs.md
    folder: docs/references/automation/catzc-base-contracts/types
    name: contract-command-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-REPO-CMDCONTRACT#4
---

# automation/Catzc.Base.Contracts/types/ContractCommand.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static IReadOnlyList<string> Compare(ContractCommand contract,...`, written with `//`.

```text
The findings of a contract against the signature read from the command's file: every disagreement, each as one message
(ADR-REPO-CMDCONTRACT#4). A computed default on the command's side is not compared.
```
