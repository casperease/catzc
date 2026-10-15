---
catzc:
  derived:
    path: docs/references/automation/catzc-base-rootconfig/tests/Test-RootConfigFiles.Tests.ps1.md
    kind: test-asset
    body_sha: c5f0990c5b37
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.RootConfig/tests/Test-RootConfigFiles.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-RootConfigFiles' -Tag 'L0', 'logic' {`.

```text
Test-RootConfigFiles over fixture root files in $TestDrive: the registry entries, git's ignore check, and the index
are mocked, so each test pins one agreement rule. A hard link stands in for a materialised link (no privilege
needed). Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
