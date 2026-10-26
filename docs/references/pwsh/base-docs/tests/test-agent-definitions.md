# pwsh/Base.Docs/tests/Test-AgentDefinitions.Tests.ps1

The tests of `Test-AgentDefinitions`, in two blocks.

## Fixture tree

A fixture `.claude/` tree in `$TestDrive` and a fixture `AgentsConfig` (`Get-Config`, `Resolve-RepoPath` and `Get-CatsDrsRuleIds` mocked),
so each test pins one rule. Fixture names are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

## Real definitions

The integrity block runs the gate on the real tree: every agent file, the shipped `agents.yml`, the real rule ids and commands, and
`.claude/CLAUDE.md`. It reads `.claude/`, which only the source tree carries, so the build run skips it.
