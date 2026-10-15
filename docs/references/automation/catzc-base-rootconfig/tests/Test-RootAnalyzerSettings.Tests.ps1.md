---
catzc:
  derived:
    path: docs/references/automation/catzc-base-rootconfig/tests/Test-RootAnalyzerSettings.Tests.ps1.md
    kind: test-asset
    body_sha: "1213ca2f87ed"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.RootConfig/tests/Test-RootAnalyzerSettings.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-RootAnalyzerSettings' -Tag 'L0', 'logic' {`.

```text
Test-RootAnalyzerSettings over a fixture root settings file in $TestDrive with the registry entries mocked, so each
test pins one outcome. Neutral fixture values ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
