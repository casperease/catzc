---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/tests/Get-ContractAssetNote.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "9ac4ac728509"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-CONTRACT#6
---

# automation/Catzc.Base.Contracts/tests/Get-ContractAssetNote.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ContractAssetNote' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT#6' {`, written with `#`.

```text
A contract asset's note is the header comment its file can carry without changing what its check compares
([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)): a YAML asset's leading '#' lines,
a schema's "$comment", and nothing for every other asset. Fixtures are a widget repository in TestDrive
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
