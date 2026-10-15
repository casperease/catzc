---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/tests/Invoke-BashTest.Tests.ps1.md
    kind: test-asset
    body_sha: f6321eba405c
    adrs:
      - ADR-AUTO-TEST#6
---

# automation/Catzc.Base.Languages/tests/Invoke-BashTest.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:root = Join-Path $TestDrive 'repo'`.

```text
Isolate through the seams ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)): a
fixture repository root in $TestDrive with a stub vendored runner and its importer.sh, a mocked engine probe
(Resolve-EngineExecutable), and a mocked bash (Invoke-Executable) whose bats writes a canned JUnit report from
tests/assets into the output folder the command names.
```
