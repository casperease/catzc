# pwsh/Catzc.Base.Reports/tests/types/CheckModes.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'CheckModes'`, written with `#`.

```text
CheckModes — the one parser of a check's mode setting, shared by every check config: an omitted mode is the default declared
once on CheckMode, and an unknown one gets the one error text. Neutral fixture values
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
