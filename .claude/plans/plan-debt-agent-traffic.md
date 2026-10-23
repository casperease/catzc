---
plan:
  status: active
  value: high
  reviewed: 2026-10-22
  class: feature
  targets:
    [
      pwsh/.internal/assets/Invoke-CatzcCommand.ps1,
      .claude/skills/report-fixed/SKILL.md,
      .claude/agents/catzc-drone.md,
      .claude/skills/plans-orchestrate/SKILL.md,
      pwsh/Catzc.Base.QualityGates/Test-Plans.ps1,
      pwsh/Catzc.Base.Timeouts/configs/timeouts.yml,
      docs/references/pwsh/catzc-base-quality-gates/Test-Plans.ps1.md,
      .claude/hooks,
    ]
---

# Debt agent traffic: fewer messages and tool calls between the orchestrator and its workers

On 2026-10-22 one orchestrator drove four workers through about forty chunks. Most of the cost was round-trips, not message length: about
four messages per heavy run for the memory queue ("your turn", "run done", the log, a status line), worker reports of 10 to 30 lines, about
ten "may I" questions on edits the rules already require, three to five tool calls per struck step (renumber, master line, value row,
`Test-Plans`), about twelve sends per import-path burst, and one Bash call per message for the orchestrator log.

## Decided (the user, 2026-10-22)

- All seven levers are taken: a lock in place of the memory queue, a one-line worker report, edits the rules require pre-approved,
  unnumbered steps with derived counts, a HOLD only to sessions that import, an automatic log, and briefs that point at the plan.

## Open steps

- [ ] The user's (a worker's permission mode refused it as an agent definition widening its own approvals, 2026-10-22):
      `.claude/agents/catzc-drone.md`: one line, an edit the domain rules require on a file the brief owns or touches (a re-imprinted head,
      inline help moved to its page, a family form the glossary flags) is pre-approved and is reported, not asked. The body kept at 20
      lines. Check: `Test-AgentDefinitions`.
- [ ] The `Record-SessionMessage` hook is built and tested (catzc-a0, 2026-10-22); left: the user registers it in `.claude/settings.json`
      (task-user-runs-and-commits). Check: one message sent between sessions appears in `out/orchestrator-<date>.log`.
- [ ] `.claude/skills/plans-orchestrate/SKILL.md` line 4: the log line is written by the hook when the hook covers it (after the step
      above). Check: `Test-AgentDefinitions`.
- [ ] Susan from HR: hindsight "If only the waiter and its config agreed": `pwsh/Catzc.Base.Timeouts/configs/timeouts.yml` line 41, the
      `budget_seconds` comment: "a holder due past it is not waited for" becomes what `pwsh/.internal/assets/Wait-CatzcRunLock.ps1` lines
      10 to 12 do (a live holder is waited for until only the run's own `-LockSeconds` remain of the budget, whatever deadline it declares,
      then the run says when to retry); the burst clause is re-read against the same lines before it is kept. A comment-only edit of a
      config read before every import, so it lands in one pass with no peer burst under way. Cost today: whether a run behind its own holder
      gives up at once depends on which file a session reads. Check: Grep the file for "not waited for" finds nothing, and
      `Invoke-TestFile` on `pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1` stays green.
- [ ] Susan from HR: hindsight "If only the session had trusted the gate it was writing for":
      `docs/references/pwsh/catzc-base-quality-gates/Test-Plans.ps1.md`, in the list after line 39 (the open-step item): one clause says a
      check that names a Verb-Noun command no module exports fails (`Test-Plans.ps1` resolves it against the exported commands). Cost today:
      the sessions that write a check learn it from a red run. Check: Grep the page for "no module exports", `Test-Links -Path` and
      `Test-Spelling -Path` on it.

## Open questions

- Susan from HR: hindsight "If only the run lock had replaced every message": `.claude/skills/plans-orchestrate/SKILL.md` lines 27 and 28
  still send `burst start` and `burst done` to the orchestrator, while `.claude/agents/implementation-orchestrator.md` line 34 lets the run
  lock hold every peer and broadcasts nothing; a full orchestrator inbox delays both. Recommendation: delete the two messages (delete beats
  a warning clause); the lock is the signal, and the orchestrator reads `out/orchestrator-<date>.log` and the run-lock holder record. Check
  after the decision: `Test-AgentDefinitions`. The user decides, since it removes a duty of a drone and of the orchestrator.
