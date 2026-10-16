---
catzc:
  immutable:
    with_body_sha: "9e2ffbe1ee22"
    path: docs/references/automation/catzc-base-docs/types/AgentsConfig.cs.md
    folder: docs/references/automation/catzc-base-docs/types
    name: agents-config-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TYPES#8
      - ADR-CONF-LOADING#4
      - ADR-REPO-AGENTS#{2,4}
---

# automation/Catzc.Base.Docs/types/AgentsConfig.cs

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
