---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Test-AdrEngineNeutrality.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: cdb7040f722c
    adrs:
      - ADR-AUTO-TEST#{3,35}
---

# automation/Catzc.Base.Docs/tests/Test-AdrEngineNeutrality.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-AdrEngineNeutrality' -Tag 'L0', 'logic', 'ADR-AUTO-TEST#35',...`, written with `#`.

```text
Test-AdrEngineNeutrality over a fixture docs/adr tree in $TestDrive, a fixture AdrsConfig, and a fixture AdrChecksConfig
(Get-Config and Resolve-RepoPath mocked). Neutral fixture names and tokens
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
