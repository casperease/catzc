---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: meta
  targets: [.claude/CLAUDE.md]
---

# Claude diet: bytes every session reads

`.claude/CLAUDE.md` is 14294 bytes (about 3574 tokens, bytes / 4, an estimate) read at the start of every session; the Sub-agents section is
4788 of them. Each agent's purpose already sits in its `description` front matter and in `agents.yml`, so the section restates a fact held
twice elsewhere. The time-safeguard trim of the same file is plan-agent-friction's step 7.

## Why its value is medium

It cuts a cost paid by every session and every spawn that loads the project instructions, but breaks nothing.

## Open steps

1. [ ] `.claude/CLAUDE.md`, section Sub-agents (4788 bytes today): each bullet cut to the agent name and one clause, the full purpose left
       to the agent's `description` and `agents.yml`; target 2400 bytes, saving about 2400 bytes (about 600 tokens) per session. The file is
       dirty in a peer's tree, so the step waits until no peer has it dirty, and it is the user's step in task-user-runs-and-commits.md.
       Check: `Test-AgentDefinitions` (it still finds every registered name listed, and none unregistered),
       `Test-Links -Path .claude/CLAUDE.md`, and `wc -c .claude/CLAUDE.md` at most 11900.
2. [ ] Hindsight d7c207 "If only one capability pointed at the index": in the same edit, the `docs/references/` line of Project structure
       names `docs/references/pwsh/index.md` as where a design round starts (about 70 bytes added, paid for by step 1's cut; no new line, no
       new file). Cost today: no robot, capability or CLAUDE.md line names the index. Check: `Test-Links -Path .claude/CLAUDE.md`, and
       `wc -c .claude/CLAUDE.md` still at most 11900.
