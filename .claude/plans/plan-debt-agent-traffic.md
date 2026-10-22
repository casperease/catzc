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
four messages per heavy run for the memory queue ("your turn", "run done", the log, a status line), worker reports of 10 to 30 lines,
about ten "may I" questions on edits the rules already require, three to five tool calls per struck step (renumber, master line, value row,
`Test-Plans`), about twelve sends per import-path burst, and one Bash call per message for the orchestrator log.

## Decided (the user, 2026-10-22)

- All seven levers are taken: a lock in place of the memory queue, a one-line worker report, edits the rules require pre-approved,
  unnumbered steps with derived counts, a HOLD only to sessions that import, an automatic log, and briefs that point at the plan.

## Open steps

- [ ] `pwsh/.internal/assets/Invoke-CatzcCommand.ps1`: a machine-wide named mutex around each run, so heavy runs on one machine go one at a
      time with no messages, and a run waiting on it says so in one line; while a session's import-path burst holds the same mutex, every
      other run waits. Its wait time is a key in `timeouts.yml`, declared once. An entry-script change, so it lands under a HOLD to every
      live peer. Check: the entry script's test file, plus two background runs started together, the second reporting that it waited.
- [ ] The burst side of the run lock (catzc-e9, 2026-10-22: the run-side lock comes first): one command that holds `Local\catzc-run` for a
      session's import-path burst, released at its end or after a declared limit, so a burst needs no HOLD and GO messages. Check: its test,
      and a run started during the hold reporting that it waited.
- [ ] `.claude/skills/report-fixed/SKILL.md`: one line, a reply to a coordinator in another session is `<step> PASS|RED|BLOCKED: <one verdict
      line>; details out/<session>-<step>.md`, the full report in that file. Merged, the file kept at 10 lines. Check: `Test-AgentDefinitions`.
- [ ] The user's (a worker's permission mode refused it as an agent definition widening its own approvals, 2026-10-22):
      `.claude/agents/catzc-worker.md`: one line, an edit the domain rules require on a file the brief owns or touches (a re-imprinted head,
      inline help moved to its page, a family form the glossary flags) is pre-approved and is reported, not asked. The body kept at 20 lines.
      Check: `Test-AgentDefinitions`.
- [ ] `.claude/skills/plans-orchestrate/SKILL.md`: a brief is `<plan> step <n or text>; owns <files>; check <check>`, never the plan's text
      again; a HOLD and a GO go to every live session that runs import-backed checks, and a session that has said it runs none (a planner)
      is left out. Merged, the file kept at 10 lines. Check: `Test-AgentDefinitions`.
- [ ] `pwsh/Catzc.Base.QualityGates/Test-Plans.ps1` and `Format-Code`'s plan handling: a step count stated in a chunk line or value row is
      rewritten from the plan's open steps when the plans are formatted, so striking a step never needs a hand sync; `Test-Plans` keeps its
      finding for anything left stale. Read how `Format-Code` treats markdown first; a new command is the fallback. Check: `Invoke-TestFile`
      on `Test-Plans.Tests.ps1` and the formatter's test, and `Test-Plans` on the live folder.
- [ ] `.claude/hooks`: a hook appends every cross-session message sent or received to `out/orchestrator-<date>.log`, so no session spends a
      tool call on its log; read the hook events Claude Code offers first (a SendMessage PostToolUse is certain, a received message may not
      be), and land what the events allow, the rest staying a Bash line. Check: the hook's test, and one send that appears in the log.
- [ ] `.claude/skills/plans-orchestrate/SKILL.md` line 4: the log line is written by the hook when the hook covers it (after the step above).
      Check: `Test-AgentDefinitions`.
