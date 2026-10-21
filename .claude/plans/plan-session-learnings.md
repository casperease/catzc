---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: feature
  targets: [.claude/learnings, .claude/skills, pwsh/Catzc.Base.Docs/Add-SessionLearning.ps1]
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
- **Decision round 2026-10-21, every recommendation taken:** the burst protocol (`hold` / `go`, `burst start` / `burst done`, no
  import-backed check during a hold) is two lines in `plans-orchestrate`, and its line 3 says a step left open names its check (Q8, Q9);
  `catzc-run` says a shared config is live for every session's next import (Q10); a peer's relayed lines are removed when it appends its own
  (Q11); the bootstrap comment page's `comment:18` shrinks to its first sentence and a link to `ADR-AUTO-TYPES-CHANGEDAFTERLOAD` when the
  page is next touched (Q12); `catzc-module` says an internal psm1 exports an explicit list, and names `Catzc.Base.CodeMeta` as the home of
  a shared head mechanism (Q13, Q15); `Test-IsRunningInVsCode` stays on `TERM_PROGRAM` until a session reports the mark missing (Q14); no
  session reads the log at start until it has filled for a week (Q16).

## Open steps

- [ ] `.claude/learnings/learned80b500.md:20`: "catzc gates" reworded to the glossary's term, and the fact brought up to date: the entry
      script `pwsh/.internal/assets/Invoke-CatzcCommand.ps1` runs several commands in one background call, so no script file is needed
      (check: `Test-Glossary` lists nothing on the file); lines 73 and 74 ("citing domain", "failed gate") reworded to the glossary's terms
      in the same edit, and `.claude/hindsight/hindsight226bbf.md:13` ("bad source") likewise (check: `Test-Glossary` lists nothing on
      either file).
- [ ] `.claude/learnings`: append catzc-49's "What I learned" lines, asked for on 2026-10-21, each rewritten to a current fact first (check:
      `Test-Markdownlint -Path '.claude/**/*.md'`).
- [ ] `.claude/skills/plans-orchestrate/SKILL.md`: the burst protocol as two lines (`hold` / `go`, a worker's `burst start` / `burst done`,
      no import-backed check during a hold), and line 3 says a step left open names its check (check: `Test-AgentDefinitions`, the body at
      most 10 lines).
- [ ] `.claude/skills/catzc-run/SKILL.md`: one line, a shared config (`file-meta.yml`, `generated-head.yml`, `glossary.yml`) is live for
      every session's next import, so its edit lands with its code in one pass and is parked in `out/` during a peer's burst (check:
      `Test-AgentDefinitions`, the body at most 10 lines).
- [ ] `.claude/skills/catzc-module/SKILL.md`: half a line, an internal psm1 exports an explicit list, so a new loader function is named in
      its `Export-ModuleMember` before its first test run (check: `Test-AgentDefinitions`).
- [ ] `.claude/skills/catzc-module/SKILL.md`, half a line merged into an existing line naming `Catzc.Base.CodeMeta` as the home of a shared
      head mechanism (check: `Test-AgentDefinitions`).
