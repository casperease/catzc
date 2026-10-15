---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/tests/New-GoWorkspace.Tests.ps1.md
    kind: test-asset
    body_sha: f4ad854ddd9b
    adrs:
      - ADR-AUTO-TEST#6
---

# automation/Catzc.Base.Languages/tests/New-GoWorkspace.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:root = Join-Path $TestDrive 'repo'`.

```text
Isolate through the seams ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)): a
fixture config, a fixture tools.yml pin, and a fixture
repository root in $TestDrive.
```
