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

- [ ] The run lock's budget fits the call that waits (catzc-e3, 2026-10-22: a re-imprint call under `timeout 300` waited on a burst until
      the Bash safeguard killed it, exit 124, because `run_lock.budget_seconds` defaults to 360): the default budget sits under the usual
      call timeout, or `Invoke-CatzcCommand` takes it from its caller, so a waiter always stops with its own "retry after it" line first;
      and a burst event whose holder process is gone (a killed burst) does not hold waiters (decided as delegated; catzc-54). (check:
      `Wait-CatzcRunLock.Tests.ps1` green with a waiter-inside-a-300-s-call case, a dead-burst-holder case, and a waiter whose parent was
      killed while queued never taking the lock (an orphaned pwsh child held a 300 s burst after its bash wrapper was stopped, catzc-54))

## Open questions

- The user's (from plan-debt-hindsight-gaps, deleted 2026-10-22 when its steps landed): a capability line saying a line that pre-approves
  agent behaviour, or a `sed -i` delete, is denied by the permission system and goes to the user. Take it or leave it.
