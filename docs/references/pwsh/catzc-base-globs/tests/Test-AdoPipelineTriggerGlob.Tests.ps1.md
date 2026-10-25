# pwsh/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-AdoPipelineTriggerGlob' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-AdoPipelineTriggerGlob is a quality gate
([ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate), drift detection): each pipeline's
actual trigger vs its globset's projection, compared as sets (ADO path filters are order-independent). A drifted
or missing pipeline is one issue; the report goes to $TestDrive.
```
