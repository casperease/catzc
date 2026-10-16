---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-GeneratedFiles.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "9c73c4bae97b"
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-GeneratedFiles' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-GeneratedFiles is a quality gate
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): each L0 case mocks every generator
at the module boundary and reads the collected issues; the report goes to $TestDrive. The integrity blocks that run it
over the real tree live beside each generator's own tests.
```
