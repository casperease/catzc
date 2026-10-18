# pwsh/Catzc.Base.Docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-GlossaryEnforcementViolations' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-GlossaryEnforcementViolations is private, so it is exercised through the module (InModuleScope, per
[ADR-PWSH-PESTER-PRIVATETHROUGHMODULE](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester-privatethroughmodule)). The glossary is built
in memory from the real GlossaryEntry/GlossaryConcept/GlossaryOptions
types and the enforcer map is passed in, in Get-CatsRuleEnforcers' shape, so no test file is read. Fixture terms
and rule codes are neutral (widget/gadget, tst —
[ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
