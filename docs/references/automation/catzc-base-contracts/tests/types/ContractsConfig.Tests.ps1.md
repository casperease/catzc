---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md
    kind: test-asset
    body_sha: cae7e80849cf
    adrs:
      - ADR-AUTO-DEFAULT#6
---

# automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'ContractsConfig' -Tag 'L0', 'logic' {`.

```text
ContractsConfig maps contracts.yml and is the one declaration of its sensible defaults
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)): an omitted key behaves exactly
like the default, a declared but unbuilt addressing mode is a valid value, and anything else fails at construction.
```
