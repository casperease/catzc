---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/tests/types/ContractValue.Tests.ps1.md
    folder: docs/references/automation/catzc-base-contracts/tests/types
    name: contract-value-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "8491e6bf3179"
    adrs:
      - ADR-REPO-CONTRACT#6
---

# automation/Catzc.Base.Contracts/tests/types/ContractValue.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'ContractValue' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT#6' {`, written with `#`.

```text
ContractValue reads a parsed JSON or YAML value as one of the JSON kinds and compares two values by JSON equality
([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)), whatever CLR type each parser chose.
```
