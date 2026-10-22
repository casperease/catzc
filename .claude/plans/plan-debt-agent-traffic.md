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
      .claude/agents/catzc-worker.md,
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

- [ ] The burst side of the run lock (the run-side lock `Local\catzc-run` landed 2026-10-22 in `Invoke-CatzcCommand.ps1`, 120 s,
      `tests.run_lock_seconds`; adding that key to `timeouts.yml` before the fresh import made the Bash hook deny every call for a minute,
      so a new key lands in `TimeoutsConfig.cs`, then an import, then the yml, as the edit reminder says): one command that holds
      `Local\catzc-run` for a session's import-path burst, released at its end or after a declared limit, so a burst needs no HOLD and GO
      messages. Check: its test, and a run started during the hold reporting that it waited.
- [ ] The user's (a worker's permission mode refused it as an agent definition widening its own approvals, 2026-10-22):
      `.claude/agents/catzc-worker.md`: one line, an edit the domain rules require on a file the brief owns or touches (a re-imprinted head,
      inline help moved to its page, a family form the glossary flags) is pre-approved and is reported, not asked. The body kept at 20
      lines. Check: `Test-AgentDefinitions`.
- [ ] `pwsh/.internal/assets/Invoke-CatzcCommand.ps1` (catzc-e3's finding, 2026-10-22): a command whose result reports a failure (an
      `Invoke-TestFile` result of Failed) counts as failed, so the run prints "0 of 1 passed" and exits 1, never "1 of 1 passed" for a red
      test. Check: the entry script's test with a red-result case, and one live red run exiting 1.
- [ ] `Catzc.Tooling.Claude` (`Start-ClaudeWorker`, starts workers as `claude --agent catzc-worker` on the agent file's model; built
      2026-10-22, its tests, analyzer, links and a live `-DryRun` green): the remaining checks, `Format-Types -DryRun`, `Test-Contracts`,
      `Test-ParameterConsistency`, `Test-Spelling` on its files, then `Build-Readme` for its README. Check: each reports 0 issues and
      `Test-GeneratedFiles` passes.
- [ ] The `Record-SessionMessage` hook is built and tested (catzc-a0, 2026-10-22); left: the user registers it in `.claude/settings.json`
      (task-user-runs-and-commits). Check: one message sent between sessions appears in `out/orchestrator-<date>.log`.
- [ ] `.claude/skills/plans-orchestrate/SKILL.md` line 4: the log line is written by the hook when the hook covers it (after the step
      above). Check: `Test-AgentDefinitions`.
