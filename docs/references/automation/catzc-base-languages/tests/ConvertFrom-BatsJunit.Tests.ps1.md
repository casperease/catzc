---
catzc:
  immutable:
    with_body_sha: "88ad9c04b391"
    path: docs/references/automation/catzc-base-languages/tests/ConvertFrom-BatsJunit.Tests.ps1.md
    folder: docs/references/automation/catzc-base-languages/tests
    name: convert-from-bats-junit-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Languages/tests/ConvertFrom-BatsJunit.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'ConvertFrom-BatsJunit' -Tag 'L0', 'logic' {`, written with `#`.

```text
ConvertFrom-BatsJunit over a canned bats JUnit report (tests/assets/bats-widget.xml, written in the shape bats 1.14
writes with --report-formatter junit). Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
