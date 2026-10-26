# pwsh/Base.Docs/tests/Get-GlossarySourceViolations.Tests.ps1

The tests of `Get-GlossarySourceViolations`. The function is private, so it is exercised through the module (`InModuleScope`, per
[ADR-PWSH-PESTER-PRIVATETHROUGHMODULE](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-privatethroughmodule)). The
sources are built in memory from the real `GlossaryConfig` type and passed in, and `drs.yml` is mocked to two fixture ADR domains, so each
test breaks exactly one cross-source fact. Fixture terms are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
