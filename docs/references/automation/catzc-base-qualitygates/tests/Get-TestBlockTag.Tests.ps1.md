---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-TestBlockTag.Tests.ps1.md
    kind: comment-page
    body_sha: "962f055c4aec"
---

# automation/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function New-FakeTest {`, written with `#`.

```text
A fake Pester test: own It-tags, an inner block, and an optional outer block. The test's .Block is
the inner block; explicit [string[]] params avoid array-of-array flattening.
```
