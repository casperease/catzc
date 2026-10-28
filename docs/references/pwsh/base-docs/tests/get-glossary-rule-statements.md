# pwsh/Base.Docs/tests/Get-GlossaryRuleStatements.Tests.ps1

The tests of `Get-GlossaryRuleStatements`. The function is private, so it is exercised through the module (`InModuleScope`, per
[ADR-PWSH-PESTER-PRIVATETHROUGHMODULE](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-privatethroughmodule)) over a
fixture DRS index and two records in `$TestDrive`. Fixture rule codes are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
