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
twice elsewhere. The time-safeguard trim of the same file is plan-agent-friction's step 3.

## Why its value is medium

It cuts a cost paid by every session and every spawn that loads the project instructions, but breaks nothing.

## Decided (the user, 2026-10-21, decision round)

- **The learnings log stays signed `Cats`** (Q7): no `persona` key on `CapabilityEntry`.

## Decided (delegated, the orchestrator, 2026-10-22)

- catzc-05's and catzc-ba's six finalize questions, all as recommended, and landed the same day in `edit-reminders.yml`, `catzc-run`,
  `drawio-declaration` and `debt-reduce`.

## Open steps

1. [ ] Susan from HR: `.claude/CLAUDE.md`, section Sub-agents (4788 bytes of a 14355-byte file, 2026-10-21): each bullet cut to the agent
       name and one clause, the full purpose left to the agent's `description` and `agents.yml`; target 2400 bytes, saving about 2400 bytes
       (about 600 tokens) per session. The file is dirty in a peer's tree, so the step waits until no peer has it dirty, and it is the
       user's step in task-user-runs-and-commits.md. Check: `Test-AgentDefinitions` (it still finds every registered name listed, and none
       unregistered), `Test-Links -Path .claude/CLAUDE.md`, and `wc -c .claude/CLAUDE.md` at most 12100.
2. [ ] Susan from HR: Hindsight d7c207 "If only one capability pointed at the index": in the same edit, the `docs/references/` line of
       Project structure names `docs/references/pwsh/index.md` as where a design round starts (about 70 bytes added, paid for by step 1's
       cut; no new line, no new file). Cost today: no robot, capability or CLAUDE.md line names the index. Check:
       `Test-Links -Path .claude/CLAUDE.md`, and `wc -c .claude/CLAUDE.md` still at most 12100.

## Open questions

- From a worker session's finalize (2026-10-22): `Test-AgentDefinitions` counts the lines of a robot or capability but never their width;
  a 231-column line in `catzc-verify` passed it and was caught only by a separate `awk` length check. Should the gate also fail a line past
  140 columns, so every merge-into-one-line edit is proved by the one gate? Recommendation: yes, one finding in the gate and its test.
- From the same finalize: `Get-Help <command> -Full` shows none of the help in a command's comment page under `docs/references/` (not even
  the synopsis of `Build-Diagrams`), only the generated syntax, so a check written as "Get-Help shows it" cannot pass. Should the loader
  feed the page's help to Get-Help, or should briefs prove help by a read of the page? Recommendation: briefs read the page; feeding
  Get-Help is a loader change for the user to weigh.
