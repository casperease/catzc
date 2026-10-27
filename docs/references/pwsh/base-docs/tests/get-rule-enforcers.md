# pwsh/Base.Docs/tests/Get-RuleEnforcers.Tests.ps1

The tests of `Get-RuleEnforcers` over a fixture test tree in `$TestDrive` and a mocked analyzer map: the AST reader credits only `-Tag`
citations, never a citation-shaped string elsewhere. The repository facts behind it, that every cited id is a real rule, are quality gates
of their own. Fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
