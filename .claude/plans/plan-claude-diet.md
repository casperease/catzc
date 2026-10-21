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

## Open questions (session-finalize catzc-05, 2026-10-21)

- Should `edit-reminders.yml` gain an entry for `pwsh/Catzc.Base.Timeouts/configs/timeouts.yml` saying a new key lands in
  `TimeoutsConfig.cs` first, then one fresh import (which rebuilds the Bash hook), then the yml line? It would replace a memory entry with a
  config line. Recommended: yes.
- Should the glossary reminder in `edit-reminders.yml` add "quote a `short:` value that holds `: `", the one YAML slip that broke every
  import today? Recommended: yes, merged into the existing reminder.
- Should `catzc-run` say in its existing line 2 that `Invoke-TestFile` takes test files only, and a language test folder runs only through
  `Test-Automation -Modules`? Recommended: yes, one clause.
- Should `drawio-declaration` say a sample under `out/` renders by `Write-DiagramMinimapData` plus declaration.py put, since
  `Build-Diagrams -Path` refuses folders outside `docs/`? Recommended: yes, one clause.
- Should the plan-edit reminder in `edit-reminders.yml` (the Show-EditReminder hook) also say "every open step names its check", the one
  Test-Plans failure a new plan hit on 2026-10-21? Recommended: yes, merged into the existing reminder.

## Open steps

1. [ ] Susan from HR: `.claude/CLAUDE.md`, section Sub-agents (4797 bytes of a 14407-byte file, 2026-10-21): each bullet cut to the agent
       name and one clause, the full purpose left to the agent's `description` and `agents.yml`; target 2400 bytes, saving about 2400 bytes
       (about 600 tokens) per session. The file is dirty in a peer's tree, so the step waits until no peer has it dirty, and it is the
       user's step in task-user-runs-and-commits.md. Check: `Test-AgentDefinitions` (it still finds every registered name listed, and none
       unregistered), `Test-Links -Path .claude/CLAUDE.md`, and `wc -c .claude/CLAUDE.md` at most 12100.
2. [ ] Susan from HR: Hindsight d7c207 "If only one capability pointed at the index": in the same edit, the `docs/references/` line of
       Project structure names `docs/references/pwsh/index.md` as where a design round starts (about 70 bytes added, paid for by step 1's
       cut; no new line, no new file). Cost today: no robot, capability or CLAUDE.md line names the index. Check:
       `Test-Links -Path .claude/CLAUDE.md`, and `wc -c .claude/CLAUDE.md` still at most 12100.
