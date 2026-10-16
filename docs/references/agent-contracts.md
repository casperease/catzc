---
catzc:
  immutable:
    with_body_sha: db82dec95bb6
    repo_status: clean
    path: docs/references/agent-contracts.md
    folder: docs/references
    name: agent-contracts
    filetype: md
    kind: reference
    language: markdown
    track: docs
    tracktype: documentation
---

# Agent contracts: what `contracts: [ADR-AI]` said, and where it lives now

## What the key said

On 2026-10-16 the robots `plan-intake` and `plan-decide` (`.claude/agents/`) carried one front-matter key beyond the fixed set:

```yaml
contracts: [ADR-AI]
```

It declared that the robot reads ADR-AI first: the contract every agent and skill acts on, one line to act on plus the why, with ADR codes
as pointers. The plan for that ADR (`.claude/plans/plan-adr-ai.md`) intended the same key on every robot and every capability, checked by
`Test-AgentDefinitions`.

## Why it is not a per-file key

The same day, ADR-REPO-AGENTS gained rule 6: a robot's front matter is a closed key set (`name`, `description`, `tools`, `disallowedTools`,
`model`, `effort`, `maxTurns`, `skills`, then the catzc head); the harness ignores any other key, and the gate rejects it. A value that is
identical on every file is a constant, not per-file data, so declaring it once is the rule (ADR-PRIN-CONFIG, ADR-PRIN-REDUCEVAR). The user
decided (questionnaire Q140, decisions-2026-10-16.md): ADR-AI is named once, and the per-file key goes.

## Where it lives now

- The CLAUDE.md session-start line names ADR-AI before the ADR index, so every session and every robot reads it first.
- A top-level `contracts:` entry in `automation/Catzc.Base.Docs/configs/agents.yml`, beside `standard:`, is the data form the gate can read
  when a check needs it.
- This page holds the meaning and the context of the key. When ADR-AI is written, its Context section absorbs this page and the page is
  deleted (ADR-PRIN-ONELIVE).
