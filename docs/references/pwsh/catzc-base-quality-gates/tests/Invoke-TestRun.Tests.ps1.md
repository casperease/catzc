# pwsh/Base.QualityGates/tests/Invoke-TestRun.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:testsDir = Join-Path $TestDrive 'widget/tests'`, written with `#`.

```text
A fixture tests/ folder with two files: widget mixes a source-only test with a runnable one; gadget is
source-only throughout. Discovery is faked over them (the Pester test shape Get-TestBlockTag walks).
```
