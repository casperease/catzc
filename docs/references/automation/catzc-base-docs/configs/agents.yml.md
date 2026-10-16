---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/configs/agents.yml.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: c176ac54b88e
    adrs:
      - ADR-REPO-AGENTS#4
---

# automation/Catzc.Base.Docs/configs/agents.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `standard: catzc-worker`, written with `#`.

```text
The sub-agent registry: one entry per sub-agent definition .claude/agents/<name>.md
([ADR-REPO-AGENTS](/docs/adr/repository/agent-definitions.md)). Per entry:
  name          the agent's name, equal to its file name without .md and to its front-matter `name`;
  supported_by  the rule citations (ADR-<CODE>#<n>) that justify the agent's existence;
  checks        the gate and check functions the agent runs or guards; `[]` when it has none.
`standard` names the standard sub-agent for delegated work
([ADR-REPO-AGENTS#4](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents4)).

Loaded via Get-Config -Config agents (shape-validated by the AgentsConfig type). The quality gate
Test-AgentDefinitions checks it against the agent files, the ADR rule ids, the loaded commands, and the
`## Sub-agents` list in .claude/CLAUDE.md.
```
