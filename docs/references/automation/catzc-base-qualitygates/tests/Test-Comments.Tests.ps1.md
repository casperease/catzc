---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-Comments.Tests.ps1.md
    kind: test-asset
    body_sha: b19d9ecf62d6
    adrs:
      - ADR-PRIN-ONELIVE#1
---

# automation/Catzc.Base.QualityGates/tests/Test-Comments.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-Comments' -Tag 'L0', 'logic' {`.

```text
Test-Comments is the gate that every long comment lives in its file's comment page and every residue and section
pair up ([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)), tested in
isolation on a widget/gadget fixture repository in $TestDrive; each case breaks the pairing one way.
```
