---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/tests/types/ContractValue.Tests.ps1.md
    kind: test-asset
    body_sha: aa64f9d26eb3
    adrs:
      - ADR-REPO-CONTRACT#6
---

# automation/Catzc.Base.Contracts/tests/types/ContractValue.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'ContractValue' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT#6' {`.

```text
ContractValue reads a parsed JSON or YAML value as one of the JSON kinds and compares two values by JSON equality
([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)), whatever CLR type each parser chose.
```
