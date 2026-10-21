---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: feature
  targets: [.claude/learnings, pwsh/Catzc.Base.Docs/Add-SessionLearning.ps1]
---

# Session learnings: the forward-memory log the finalizer writes

`Add-SessionLearning` appends each session's "What I learned" lines to `.claude/learnings/`, a first-in, first-out log of `learned<sha>.md`
files (5 files of 50 learnings, declared on `LearningsConfig`), written to pass the markdown lint. Left: one session's lines that have not
arrived, and two ideas for the next step.

## Why its value is medium

The log is a shortcut to current facts for the next agents; it already holds 56 and fills from every finalize, so what is left only adds
reach.

## Decided (2026-10-21, from the user)

- A learning completes "In hindsight I wish I knew this fact: …": a fact true of the repository now, never the story of a session.
- Five files of fifty learnings, tracked, the oldest dropped first, repeats kept; nothing reads the log at session start yet.
- Every session appends its own lines; lines relayed through another session are not kept in the log.

## Open steps

- [ ] `.claude/learnings/learned80b500.md:20`: "catzc gates" reworded to the glossary's term, and the fact brought up to date: the entry
      script `pwsh/.internal/assets/Invoke-CatzcCommand.ps1` runs several commands in one background call, so no script file is needed
      (check: `Test-Glossary` lists nothing on the file).
- [ ] `.claude/learnings`: append catzc-49's "What I learned" lines, asked for on 2026-10-21, each rewritten to a current fact first (check:
      `Test-Markdownlint -Path '.claude/**/*.md'`).

## Open questions

- From the orchestrator's finalizer (catzc-6b, 2026-10-21): should `plans-orchestrate` gain the burst protocol as its fourth and fifth
  messages (`hold` / `go`, a worker's `burst start` / `burst done`), and say the orchestrator runs no import-backed check during a hold?
  Recommendation: yes, two lines in the capability; the session ran three bursts and one outage on it by hand.
- Should `plans-orchestrate` say a step left open names its check too ("Check: …"), since `Test-Plans` rejects a waiting step without one?
  Recommendation: yes, folded into its line 3.

- From catzc-c3's learnings (2026-10-21): should the `catzc-run` capability say that a shared config (`file-meta.yml`, `generated-head.yml`,
  `glossary.yml`) is live for every session's next import, so an edit to one lands with its code in one pass and is parked in `out/` during
  a peer's burst? Recommendation: yes, one line in the capability, which shrinks what a worker must learn by outage.

- Each session now appends its own lines, so the lines catzc-5b logged on seven peers' behalf (catzc-e8, -e2, -33, -03, -80, -59, -91) can
  double. Remove a peer's relayed lines when it appends its own (as done for catzc-4f), or remove all relayed lines now? Recommendation:
  when it appends its own.

- From the VS Code types session (2026-10-21): the changed-after-load behaviour now reads in three places (rule
  `ADR-AUTO-TYPES-CHANGEDAFTERLOAD`, the ADR's "Stale types in a running process" section, and `comment:18` of the bootstrap's comment
  page). Should the comment page section shrink to its first sentence and a link to the rule, so the next reader reads one place?
  Recommendation: yes, when the page is next touched.
- Same session: should the `catzc-module` capability say that an internal `psm1` exports an explicit list, so a new loader function is named
  in its `Export-ModuleMember` before its first test run? Recommendation: yes, half a line; the session paid one test run to find it.
- Same session: `Test-IsRunningInVSCode` reads only `TERM_PROGRAM`, the mark VS Code sets on every terminal it opens. Should it also read
  the PowerShell extension's host name, in case that console lacks the mark? Recommendation: no, until a session reports the mark missing
  there.
- Should a session read the newest learnings file at start, at the cost of up to 50 lines of context? Recommendation: not yet; first let the
  log fill for a week and see which lines get reused.
- Superseded by the tree (the planner, 2026-10-21): "should one cats command run one check in the background" is answered by
  `pwsh/.internal/assets/Invoke-CatzcCommand.ps1` and catzc-run's step 2, which landed from plan-agent-shortcuts; nothing is left to ask.
