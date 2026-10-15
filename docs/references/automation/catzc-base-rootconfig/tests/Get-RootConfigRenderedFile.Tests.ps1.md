---
catzc:
  derived:
    path: docs/references/automation/catzc-base-rootconfig/tests/Get-RootConfigRenderedFile.Tests.ps1.md
    kind: test-asset
    body_sha: "0f0af0b94e14"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.RootConfig/tests/Get-RootConfigRenderedFile.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-RootConfigRenderedFile' -Tag 'L0', 'logic' {`.

```text
Get-RootConfigRenderedFile over a mocked generator dispatch: a single-file generator's string and a multi-file
generator's { Target; Content } records normalise to the same records, and every shape that would write a file the
entry does not name throws. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
