# pwsh/Catzc.Base.Exporter/tests/New-CatzcNuGetPackage.Tests.ps1

<!-- cspell:ignore nfunction -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:source = Join-Path $TestDrive...`, written with `#`.

```text
A minimal fixture build (neutral names,
[ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)), packed ONCE: every
assertion below is a facet
of the one pack ([ADR-AUTO-TEST-ONEIMPORTPERCASE](/docs/adr/automation/test-automation.md#rule-adr-auto-test-oneimportpercase)) —
Compress-PSResource costs real time.
```
