# pwsh/Base.Docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1

The tests of `Get-GlossaryDefinitionViolations`. The function is private, so it is exercised through the module (`InModuleScope`, per
[ADR-PWSH-PESTER-PRIVATETHROUGHMODULE](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-privatethroughmodule)). A
fixture ADR index and two ADRs live in `$TestDrive`, and the glossary is built in memory from the real types. Fixture terms and rule codes
are neutral ([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
