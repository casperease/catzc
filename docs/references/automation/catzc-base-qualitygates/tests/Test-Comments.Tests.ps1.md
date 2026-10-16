---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-Comments.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: test-comments-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: dae203cc67d6
    adrs:
      - ADR-PRIN-ONELIVE#1
---

# automation/Catzc.Base.QualityGates/tests/Test-Comments.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-Comments' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-Comments is the gate that every long comment lives in its file's comment page and every section
still names a code line of the file ([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)), tested in
isolation on a widget/gadget fixture repository in $TestDrive; each case breaks the page or the file one way.
```
