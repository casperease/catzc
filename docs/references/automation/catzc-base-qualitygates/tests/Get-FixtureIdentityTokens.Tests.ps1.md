---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-FixtureIdentityTokens.Tests.ps1.md
    kind: test-asset
    body_sha: "975f37e7c0f1"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-FixtureIdentityTokens' -Tag 'L1', 'logic' {`.

```text
Get-FixtureIdentityTokens over a fixture automation tree in $TestDrive (Get-RepositoryRoot mocked): the fixture
azure.yml / customer.yml are constructed as their registered C# config types, so the YAML below is a valid instance
of each. L1: it reads files and constructs the registered types. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)); the disjointness from the live
identities is the quality gate Test-ConfigIdentityHygiene.
```
