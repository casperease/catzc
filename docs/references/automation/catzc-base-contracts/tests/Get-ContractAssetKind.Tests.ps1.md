---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/tests/Get-ContractAssetKind.Tests.ps1.md
    kind: test-asset
    body_sha: d72ce37b40f0
    adrs:
      - ADR-REPO-CONTRACT#6
---

# automation/Catzc.Base.Contracts/tests/Get-ContractAssetKind.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-ContractAssetKind' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT#6' {`.

```text
The name rule of a contract asset's kind
([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)): the suffix picks schema or sample,
and any other name is a fragment, or a presence when empty.
```
