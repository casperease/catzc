---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Test-AgentDefinitions.Tests.ps1.md
    kind: test-asset
    body_sha: dca4e3f1099e
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-AgentDefinitions' -Tag 'L0', 'logic' {`.

```text
Test-AgentDefinitions over a fixture .claude/ tree in $TestDrive and a fixture AgentsConfig (Get-Config,
Resolve-RepoPath, and Get-CatsAdrRuleIds mocked), so each test pins one rule. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)); the real-tree run is the
integrity block at the end of this file.
```

## comment:2

Above `Describe 'Test-AgentDefinitions — real agent definitions' -Tag 'L1',...`.

```text
The real tree: every agent file, the shipped agents.yml, the real rule ids and commands, and .claude/CLAUDE.md.
It reads .claude/, which only the source tree carries, so the build run skips it.
```
