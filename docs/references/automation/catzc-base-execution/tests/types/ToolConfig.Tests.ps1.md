# automation/Catzc.Base.Execution/tests/types/ToolConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
The typed record over one tools.yml entry. It rejects keys it does not map (a dropped key would be invisible
to every caller), and these pin the optional flags the provisioning loops branch on. Fixture tokens are
neutral ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
