# pwsh/Base.Docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1

The tests of `Get-GlossaryEnforcementViolations`. The function is private, so it is exercised through the module (`InModuleScope`, per
[ADR-PWSH-PESTER-PRIVATETHROUGHMODULE](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-privatethroughmodule)). The
glossary is built in memory from the real types and the enforcer map is passed in, in the shape of `Get-CatsRuleEnforcers`, so no test file
is read. Fixture terms and rule codes are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).

The enforcer map has three rules: `ADR-TST-WIDGET-TESTED` is cited by a test, `ADR-TST-WIDGET-ANALYZED` by an analyzer, and
`ADR-TST-WIDGET-BARE` by nothing.
