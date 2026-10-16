---
catzc:
  immutable:
    with_body_sha: fa7dfa339f20
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-FixtureIdentityTokens.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: get-fixture-identity-tokens-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-FixtureIdentityTokens' -Tag 'L1', 'logic' {`, written with `#`.

```text
Get-FixtureIdentityTokens over a fixture automation tree in $TestDrive (Get-RepositoryRoot mocked): the fixture
azure.yml / customer.yml are constructed as their registered C# config types, so the YAML below is a valid instance
of each. L1: it reads files and constructs the registered types. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)); the disjointness from the live
identities is the quality gate Test-ConfigIdentityHygiene.
```
