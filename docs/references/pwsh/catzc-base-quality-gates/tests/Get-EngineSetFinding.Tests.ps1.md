# pwsh/Catzc.Base.QualityGates/tests/Get-EngineSetFinding.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-EngineSetFinding' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-EngineSetFinding over fixture texts, with a fixture engine set — widget, gadget and sprocket stand in for the
model's engines ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)), so the finder is
proven to read the names and their count from its caller, never from a literal of its own.
```
