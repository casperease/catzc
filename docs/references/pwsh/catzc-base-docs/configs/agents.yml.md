# pwsh/Catzc.Base.Docs/configs/agents.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `standard: catzc-drone`, written with `#`.

```text
The sub-agent registry: one entry per sub-agent definition .claude/agents/<name>.md
([ADR-REPO-AGENTS](/docs/drs/repository/agent-definitions.md)). Per entry:
  name          the agent's name, equal to its file name without .md and to its front-matter `name`;
  supported_by  the rule citations (ADR-<CODE>#<n>) that justify the agent's existence;
  checks        the gate and check functions the agent runs or guards; `[]` when it has none;
  persona       the person name a robot with a personality signs its log lines with (Add-SessionLearning -Author), e.g. Jack;
                left out for a robot that keeps no log.
`standard` names the standard sub-agent for delegated work
([ADR-REPO-AGENTS-STANDARDDRONE](/docs/drs/repository/agent-definitions.md#rule-adr-repo-agents-standarddrone)).

Loaded via Get-Config -Config agents (shape-validated by the AgentsConfig type). The quality gate
Test-AgentDefinitions checks it against the agent files, the ADR rule ids, the loaded commands, and the
`## Sub-agents` list in .claude/CLAUDE.md.
```

## comment:2

Above `- name: 2020-hindsight`, written with `#`.

```text
Reads what sessions learned the hard way, finds where the tree already knew or does not, and keeps the hindsight log: smug in form, checked in fact.
A robot reading a long log caps its probes per line and writes in batches: a 40-turn roof ended this one's first run before its one write.
```
