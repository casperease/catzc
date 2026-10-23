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

## Open questions

- The orchestrator's finalize (2026-10-22), proposals to shrink what the next session reads, none applied: (1) one merged line in
  `.claude/skills/plans-orchestrate/SKILL.md`: at most two heavy drones at a time on this devbox, bursts chained drone to drone, one unit
  per `Invoke-CatzcCommand` call (today only in the orchestrator's memory); (2) the parent check landed (2026-10-22), so drop the "never
  stop a queued burst by TaskStop" caution from anyone's notes, since the waiter now stops itself; (3) `docs/drs/repository/file-meta.md`
  FILEISNODE gains the folding sentence (a cited bare record code stands for its rules; `drs_total` counts before folding), so no reader
  re-derives it. Take or leave each.

- catzc-54's finalize (2026-10-22), a proposal, not applied: one line in `.claude/skills/catzc-verify/SKILL.md`, "a body diff after
  `Format-Code` may be a long comment moved verbatim to its comment page; check the page before reporting a word change", so a drone does
  not raise a re-imprint's comment move as a body change. Take it or leave it.

- The orchestrator's third finalize (2026-10-22), a proposal, not applied: one line in `.claude/skills/catzc-run/SKILL.md`, "inside
  `Invoke-CatzcCommand` call the gate itself, never a count of its issues", since a printed count passes the call whatever it is. Take it or
  leave it.

- The orchestrator's second finalize (2026-10-22), proposals, none applied: (1) one line in `.claude/skills/catzc-verify/SKILL.md`, "a test
  file red on HEAD is fixed inside the burst that touches its subject, never left out", since a left-out test cannot judge the change; (2) a
  burst leaves out only test files red for commit state or a named race, each listed in its plan step with what clears it. Take or leave
  each.

- The user's (from plan-debt-hindsight-gaps, deleted 2026-10-22 when its steps landed): a capability line saying a line that pre-approves
  agent behaviour, or a `sed -i` delete, is denied by the permission system and goes to the user. Take it or leave it.

- catzc-6e's finalize (2026-10-23): a run-lock holder whose session has ended while its pwsh keeps running (the pid 15324 stall, 2026-10-22:
  a gone holder process was ruled out by a test, so it was most likely a live orphan) still holds the lock to its deadline, and every waiter
  now waits on it until its budget leaves only `-LockSeconds`. Should a holder whose own caller is gone count as gone, as a waiter whose
  caller is gone already does in `Wait-CatzcRunLock.ps1`? Take it or leave it.

- catzc-6e's finalize (2026-10-23), proposals to shrink what the next session reads, none applied: (1) one line in
  `.claude/skills/catzc-run/SKILL.md`, "the draw.io kit runs as `uv run --no-sync --project python python …`", so no session re-derives the
  no-sync rule from a correction; (2) now that `Enter-CatzcBurst` takes the run lock for an import-path burst, retire the HOLD and "burst
  done" broadcast to every peer (this session got two that changed nothing it did), keeping a message only for a session that holds an
  import open outside the lock. Take or leave each.
