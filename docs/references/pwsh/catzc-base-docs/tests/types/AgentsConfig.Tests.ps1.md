# pwsh/Catzc.Base.Docs/tests/types/AgentsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'AgentsConfig' -Tag 'L0', 'logic', 'ADR-REPO-AGENTS-BACKEDBYRULE' {`, written with `#`.

```text
Validates the compiled AgentsConfig type directly — the constructor stops a malformed agents.yml from ever
producing an instance. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
