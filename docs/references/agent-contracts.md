# Agent contracts: what `contracts: [ADR-REPO-AI]` said, and where it lives now

## What the key said

On 2026-10-16 the robots `plan-intake` and `plan-decide` (`.claude/agents/`) carried one front-matter key beyond the fixed set:

```yaml
contracts: [ADR-REPO-AI]
```

It declared that the robot reads ADR-REPO-AI first: the contract every agent and skill acts on, one line to act on plus the why, with ADR
codes as pointers. The plan for that ADR (`.claude/plans/plan-adr-ai.md`) intended the same key on every robot and every capability, checked
by `Test-AgentDefinitions`.

## Why it is not a per-file key

ADR-REPO-AGENTS-ROBOTBODYLIMIT makes a robot's front matter a closed key set (`name`, `description`, `tools`, `disallowedTools`, `model`,
`effort`, `maxTurns`, `skills`, then the catzc head); the harness ignores any other key, and the gate rejects it. A value that is identical
on every file is a constant, not per-file data, so declaring it once is the rule (PDR-CONFIG, PDR-REDUCEVAR). ADR-REPO-AGENTS-ROBOTBODYLIMIT
holds the decision: ADR-REPO-AI is named once, and no file carries the per-file key.

## Where it lives now

- The CLAUDE.md session-start line names ADR-REPO-AI before the ADR index, so every session and every robot reads it first.
- A top-level `contracts:` entry in `pwsh/Base.Docs/configs/agents.yml`, beside `standard:`, is the data form the gate can read when a
  check needs it.
- This page holds the meaning and the context of the key. When ADR-REPO-AI is written, its Context section absorbs this page and the page is
  deleted (PDR-ONELIVE).
