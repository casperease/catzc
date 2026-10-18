# pwsh/Catzc.Base.Docs/types/AgentsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The sub-agent registry (configs/agents.yml): one entry per sub-agent definition under .claude/agents/, with the
ADR rules that support it and the checks it runs or guards, plus the one standard agent
([ADR-REPO-AGENTS#2](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents2),
[ADR-REPO-AGENTS#4](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents4)). Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Docs.AgentsConfig), so Get-Config -Config agents returns
this typed record ([ADR-CONF-LOADING#4](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading4)).
Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Constructing an instance validates the file, collecting every violation into one ArgumentException:
  - only the top-level keys standard and agents, both required;
  - agents is a non-empty LIST of well-formed AgentEntry mappings with distinct names;
  - standard names one of the entries.
The cross-checks against the agent files, the rule ids, the commands, and .claude/CLAUDE.md are the quality gate
Test-AgentDefinitions.
```

## comment:2

Above `public IReadOnlyList<string> contracts { get; } = new[] { "ADR-AI" };`, written with `//`.

```text
The contracts every robot and capability names in its front matter under `contracts`, the default declared once here
([ADR-REPO-AGENTS#6](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents6)).
```

## comment:3

Above `public int agent_body_lines { get; } = 20;`, written with `//`.

```text
The most body lines an agent file may have, the default declared once here and overridable in roofs
([ADR-REPO-AGENTS#6](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents6)).
```

## comment:4

Above `public int capability_lines { get; } = 10;`, written with `//`.

```text
The most lines a capability file may have outside its catzc head, delimiters excluded
([ADR-REPO-AGENTS#8](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents8)).
```
