---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-TestBlockTag.Tests.ps1.md
    kind: test-asset
    body_sha: "961ecdb75db4"
---

# automation/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `function New-FakeTest {`.

```text
A fake Pester test: own It-tags, an inner block, and an optional outer block. The test's .Block is
the inner block; explicit [string[]] params avoid array-of-array flattening.
```
