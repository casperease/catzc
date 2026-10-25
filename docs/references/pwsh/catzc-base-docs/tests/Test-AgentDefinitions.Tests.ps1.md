# pwsh/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-AgentDefinitions' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-AgentDefinitions over a fixture .claude/ tree in $TestDrive and a fixture AgentsConfig (Get-Config,
Resolve-RepoPath, and Get-CatsDrsRuleIds mocked), so each test pins one rule. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)); the real-tree run is the
integrity block at the end of this file.
```

## comment:2

Above `Describe 'Test-AgentDefinitions — real agent definitions' -Tag 'L1',...`, written with `#`.

```text
The real tree: every agent file, the shipped agents.yml, the real rule ids and commands, and .claude/CLAUDE.md.
It reads .claude/, which only the source tree carries, so the build run skips it.
```
