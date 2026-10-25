# pwsh/Catzc.Base.Drs/tests/Get-DrsRuleSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-DrsRuleSet'`, written with `#`.

```text
Get-DrsRuleSet over a fixture DrsConfig (Get-Config mocked): the flattening and effective codes are DrsConfig
construction rules (its type test), so this pins only the projection and the -Domain filter. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `Describe 'Get-DrsRuleSet integrity'`, written with `#`.

```text
Integrity: drs.yml and the ADR rule files agree, through the quality gate Test-DrsRegistry
([ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).
```
