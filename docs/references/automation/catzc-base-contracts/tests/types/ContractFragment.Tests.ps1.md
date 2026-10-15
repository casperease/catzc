---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/tests/types/ContractFragment.Tests.ps1.md
    kind: test-asset
    body_sha: "57e0f62a3740"
    adrs:
      - ADR-REPO-CONTRACT#6
---

# automation/Catzc.Base.Contracts/tests/types/ContractFragment.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'ContractFragment' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT#6' {`.

```text
ContractFragment checks that a real file contains a fragment
([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)): JSON and YAML by key subset, any
other text by its non-blank lines in order. Each rule has a passing and a failing target.
```
