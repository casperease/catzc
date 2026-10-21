# pwsh/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:harness = 'Catzc.Base.QualityGates'`, written with `#`.

```text
Build-Modules (Catzc.Base.Exporter) is the boundary: mocked here, so this test file proves the wiring
without a real build.
```
