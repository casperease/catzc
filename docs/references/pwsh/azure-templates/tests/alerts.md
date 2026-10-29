# pwsh/Azure.Templates/tests/Alerts.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `if ($script:bicepReady) {`, written with `#`.

```text
Each template builds once for the file, before any It runs
([ADR-AUTO-TEST-SETUPONCE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-setuponce)).
```
