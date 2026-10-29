# pwsh/Azure.Templates/tests/Test-BicepTemplateCompliance.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `$bicep = Resolve-ToolExecutable -Tool bicep`, written with `#`.

```text
The templates build once for the file, before the It runs
([ADR-AUTO-TEST-SETUPONCE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-setuponce)).
```
