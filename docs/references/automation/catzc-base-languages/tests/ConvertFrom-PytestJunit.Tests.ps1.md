---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/tests/ConvertFrom-PytestJunit.Tests.ps1.md
    kind: test-asset
    body_sha: ecdc3010c342
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Languages/tests/ConvertFrom-PytestJunit.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'ConvertFrom-PytestJunit' -Tag 'L0', 'logic' {`.

```text
ConvertFrom-PytestJunit over a canned pytest JUnit report in tests/assets: one result per top-level test function,
parametrised cases folded in. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
