# pwsh/Catzc.Base.Docs/tests/Get-GlossarySourceViolations.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-GlossarySourceViolations' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-GlossarySourceViolations is private, so it is exercised through the module (InModuleScope, per
[ADR-PWSH-PESTER#4](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester4)). The sources are built
in memory from the real GlossaryConfig type and passed in, and adrs.yml
is mocked to two fixture ADR domains, so each test breaks exactly one cross-source fact. Fixture terms are neutral
(widget/gadget, [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
