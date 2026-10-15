---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Test-AdrEngineNeutrality.Tests.ps1.md
    kind: test-asset
    body_sha: "0db6595be86e"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.Docs/tests/Test-AdrEngineNeutrality.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-AdrEngineNeutrality' -Tag 'L0', 'logic', 'ADR-AUTO-TEST#35',...`.

```text
Test-AdrEngineNeutrality over a fixture docs/adr tree in $TestDrive, a fixture AdrsConfig, and a fixture AdrChecksConfig
(Get-Config and Resolve-RepoPath mocked). Neutral fixture names and tokens
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
