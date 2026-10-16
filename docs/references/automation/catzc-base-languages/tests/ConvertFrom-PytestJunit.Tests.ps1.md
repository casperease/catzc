---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/tests/ConvertFrom-PytestJunit.Tests.ps1.md
    folder: docs/references/automation/catzc-base-languages/tests
    name: convert-from-pytest-junit-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "9302961a8d12"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Languages/tests/ConvertFrom-PytestJunit.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'ConvertFrom-PytestJunit' -Tag 'L0', 'logic' {`, written with `#`.

```text
ConvertFrom-PytestJunit over a canned pytest JUnit report in tests/assets: one result per top-level test function,
parametrised cases folded in. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
