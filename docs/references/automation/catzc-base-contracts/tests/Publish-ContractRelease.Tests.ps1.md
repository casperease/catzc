---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/tests/Publish-ContractRelease.Tests.ps1.md
    kind: test-asset
    body_sha: ef55afa6b1d7
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-CONTRACT#5
---

# automation/Catzc.Base.Contracts/tests/Publish-ContractRelease.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Publish-ContractRelease' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT#5' {`.

```text
Publish-ContractRelease freezes a unit's draft as a released version folder
([ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)): an exact copy plus its .frozen
record, refusing the draft itself, the devbox build version, and a folder that exists. Fixtures are a widget
repository in TestDrive ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)); the settings
are mocked, so the logic tests read no shipped config.
```
