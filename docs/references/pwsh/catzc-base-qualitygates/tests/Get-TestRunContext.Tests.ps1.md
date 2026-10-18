# pwsh/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-TestRunContext' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-TestRunContext over fixture locations; the session actor and the tool lookup are mocked, so no real process or
PATH state decides the outcome ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
