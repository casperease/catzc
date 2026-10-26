# pwsh/Catzc.Base.Docs/types/AgentsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The sub-agent registry (configs/agents.yml): one entry per sub-agent definition under .claude/agents/, with the
ADR rules that support it and the checks it runs or guards
([ADR-REPO-AGENTS-BACKEDBYRULE](/docs/drs/repository/agent-definitions.md#rule-adr-repo-agents-backedbyrule)). Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Docs.AgentsConfig), so Get-Config -Config agents returns
this typed record ([ADR-CONF-LOADING-CSHARPCONFIGTYPE](/docs/drs/configuration/module-config-loading.md#rule-adr-conf-loading-csharpconfigtype)).
Mirrors the YAML mapping (snake_case keys,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

Constructing an instance validates the file, collecting every violation into one ArgumentException:
  - only the top-level keys agents (required), roofs and contracts;
  - agents is a non-empty LIST of well-formed AgentEntry mappings with distinct names.
The cross-checks against the agent files, the rule ids, the commands, and .claude/CLAUDE.md are the quality gate
Test-AgentDefinitions.
```

## comment:2

Above `public IReadOnlyList<string> contracts { get; } = new[] { "ADR-REPO-AI" };`, written with `//`.

```text
The contracts every robot and capability names in its front matter under `contracts`, the default declared once here
([ADR-REPO-AGENTS-ROBOTBODYLIMIT](/docs/drs/repository/agent-definitions.md#rule-adr-repo-agents-robotbodylimit)).
```

## comment:3

Above `public int agent_body_lines { get; } = 20;`, written with `//`.

```text
The most body lines an agent file may have, the default declared once here and overridable in roofs
([ADR-REPO-AGENTS-ROBOTBODYLIMIT](/docs/drs/repository/agent-definitions.md#rule-adr-repo-agents-robotbodylimit)).
```

## comment:4

Above `public int capability_lines { get; } = 30;`, written with `//`.

```text
The most lines a capability file may have outside its catzc head, delimiters excluded
([ADR-REPO-AGENTS-CAPABILITYFILE](/docs/drs/repository/agent-definitions.md#rule-adr-repo-agents-capabilityfile)).
```
