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

- [ ] Decided by the orchestrator as delegated (2026-10-23), from the finalizes of 2026-10-22 and 2026-10-23, every proposal taken, each
      merged into an existing line (at most 10 lines and 140 columns a file): `.claude/skills/plans-orchestrate/SKILL.md`, at most two heavy
      drones at a time, bursts chained drone to drone, one unit per `Invoke-CatzcCommand` call, a step's check names a command a module
      exports, and the orchestrator's plan checks batch into one run per worker report; `.claude/skills/catzc-verify/SKILL.md`, a body diff
      after `Format-Code` may be a comment moved to its page (check the page first), and a test file red on HEAD is fixed inside the burst
      that touches its subject, a burst leaving out only files red for commit state or a named race, each listed in its step;
      `.claude/skills/catzc-run/SKILL.md`, inside `Invoke-CatzcCommand` the gate itself is called, never a count of its issues, the draw.io
      kit runs as `uv run --no-sync --project python python …`, and a line pre-approving agent behaviour or a `sed -i` delete is denied by
      the permission system and goes to the user. Check: `Test-AgentDefinitions`.
- [ ] Decided by the orchestrator as delegated (2026-10-23; catzc-6e's finalize): `pwsh/.internal/assets/Wait-CatzcRunLock.ps1`, a holder
      whose own caller is gone counts as gone, as a waiter whose caller is gone already does, so an orphaned pwsh no longer holds every
      waiter to its deadline. Check: its test file green with a new orphaned-holder case, `Test-ScriptAnalyzer -Path` at 0.
