---
catzc:
  immutable:
    with_body_sha: "07d76f71d25a"
    path: docs/references/automation/catzc-base-contracts/tests/types/ContractSchema.Tests.ps1.md
    folder: docs/references/automation/catzc-base-contracts/tests/types
    name: contract-schema-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-REPO-CONTRACT#6
---

# automation/Catzc.Base.Contracts/tests/types/ContractSchema.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'ContractSchema' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT#6' {`, written with `#`.

```text
ContractSchema validates a parsed value against a bounded JSON Schema subset
([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)): type, required, properties,
additionalProperties (a boolean), enum, items (one schema) and const; the annotations $schema, $id, $comment, title,
description and examples are ignored. Every other keyword, and every unsupported form of a supported one, is a finding.
Each keyword has a passing and a failing value; schemas and values are JSON literals.
```
