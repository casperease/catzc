# pwsh/Base.Docs/configs/agents.yml

The sub-agent registry: one entry per sub-agent definition `.claude/agents/<name>.md`
([ADR-REPO-AGENTS](../../../../drs/repository/agent-definitions.md)). It is loaded through `Get-Config -Config agents`, shape-validated by
the [AgentsConfig](../types/agents-config.md) type, and checked by `Test-AgentDefinitions` against the agent files, the ADR rule ids, the
loaded commands and the `## Sub-agents` list in `.claude/CLAUDE.md`.

## Entry keys

Each entry of `agents:` carries (see [AgentEntry](../types/agent-entry.md)):

- **`name`** — the agent's name, equal to its file name without `.md` and to its front-matter `name`.
- **`supported_by`** — the rule citations (`ADR-<CODE>#<n>`) that justify the agent's existence.
- **`checks`** — the gate and check functions the agent runs or guards; `[]` when it has none.
- **`model_reason`** — why the agent runs above the default model, when it does.
- **`persona`** — the person name a robot with a personality signs its log lines with (`Add-SessionLearning -Author`), for example Jack;
  left out for a robot that keeps no log.

## The standard agent

The registry holds one standard agent, which takes one task from a coordinator's brief when no specialised agent fits; the other agents name
their job and are listed in its description
([ADR-REPO-AGENTS-STANDARDDRONE](../../../../drs/repository/agent-definitions.md#rule-adr-repo-agents-standarddrone)).

## Robot behaviour

A robot that reads a long log caps its probes per line and writes in batches: a turn roof once ended the hindsight robot's first run before
its one write.
