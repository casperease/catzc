# pwsh/Catzc.Base.QualityGates/tests/Split-CachedFile.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Split-CachedFile' -Tag 'L0', 'logic', 'ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS' {`, written with `#`.

```text
The result-cache halves shared by Format-Code and the analyzer: Split-CachedFile reads, Update-ResultCache writes,
Get-ContentStamp fingerprints a check's inputs ([ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS](/docs/adr/automation/caching.md#rule-adr-auto-cache-checkedfilesacrosssessions)).
Neutral fixture names ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
