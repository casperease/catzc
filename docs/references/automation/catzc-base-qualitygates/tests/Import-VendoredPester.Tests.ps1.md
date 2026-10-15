---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Import-VendoredPester.Tests.ps1.md
    kind: test-asset
    body_sha: "31983d3d8bbe"
---

# automation/Catzc.Base.QualityGates/tests/Import-VendoredPester.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:codeRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))`.

```text
A fake code root with one vendored version; every module operation is mocked, so the Pester running this
test is never touched.
```
