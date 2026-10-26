# pwsh/Base.Docs/tests/Get-GlossaryAnchorViolations.Tests.ps1

The tests of `Get-GlossaryAnchorViolations`. The function is private, so it is exercised through the module (`InModuleScope`, per
[ADR-PWSH-PESTER-PRIVATETHROUGHMODULE](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-privatethroughmodule)). A
fixture ADR index and ADR live in `$TestDrive`, and the glossary is built in memory from the real types, so each test breaks exactly one
anchoring fact. Fixture terms and rule codes are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
