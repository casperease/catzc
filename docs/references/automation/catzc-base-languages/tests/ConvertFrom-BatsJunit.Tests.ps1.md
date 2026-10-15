---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/tests/ConvertFrom-BatsJunit.Tests.ps1.md
    kind: test-asset
    body_sha: a91cd07eb0e9
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Languages/tests/ConvertFrom-BatsJunit.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'ConvertFrom-BatsJunit' -Tag 'L0', 'logic' {`.

```text
ConvertFrom-BatsJunit over a canned bats JUnit report (tests/assets/bats-widget.xml, written in the shape bats 1.14
writes with --report-formatter junit). Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
