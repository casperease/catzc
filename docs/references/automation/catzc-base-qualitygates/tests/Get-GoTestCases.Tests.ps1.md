---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-GoTestCases.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: get-go-test-cases-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "644771053f63"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-GoTestCases.Tests.ps1

<!-- cspell:ignore Testlowercase -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-GoTestCases' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-GoTestCases over a fixture Go test folder in $TestDrive (the go config mocked to its defaults): the Go tests are
read from the *_test.go source, never by running go. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
