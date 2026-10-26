# pwsh/Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'EngineSetCheck'`, written with `#`.

```text
EngineSetCheck maps the engine-set check's settings and matches its phrases against the engine names it is given —
widget, gadget and sprocket stand in for the model's engines
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)) — so no engine name or count is a
literal of the check ([ADR-AUTO-ENGINE-THREEENGINES](/docs/drs/automation/execution-engines.md#rule-adr-auto-engine-threeengines)).
```
