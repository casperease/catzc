# automation/Catzc.Base.QualityGates/tests/Import-VendoredPester.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:codeRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))`, written with `#`.

```text
A fake code root with one vendored version; every module operation is mocked, so the Pester running this
test is never touched.
```
