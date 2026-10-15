---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/tests/types/ContractSchema.Tests.ps1.md
    kind: test-asset
    body_sha: df86da30f121
    adrs:
      - ADR-REPO-CONTRACT#6
---

# automation/Catzc.Base.Contracts/tests/types/ContractSchema.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'ContractSchema' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT#6' {`.

```text
ContractSchema validates a parsed value against a bounded JSON Schema subset
([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)): type, required, properties,
additionalProperties (a boolean), enum, items (one schema) and const; the annotations $schema, $id, $comment, title,
description and examples are ignored. Every other keyword, and every unsupported form of a supported one, is a finding.
Each keyword has a passing and a failing value; schemas and values are JSON literals.
```
