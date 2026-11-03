# pwsh/Base.Exporter/tests/Export-Catzc.Install.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `$script:roots = @{}`, written with `#`.

```text
One build of base per run: the first Export-Catzc builds it into the default built folder, and every other install reads that tree
through Install-Catzc, whose default source it is (ADR-AUTO-TEST-SETUPONCE).
```
