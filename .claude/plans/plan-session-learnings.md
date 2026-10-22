---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: feature
  targets:
    [
      .claude/learnings,
      .claude/skills,
      .claude/agents/plan-decide.md,
      .claude/agents/catzc-worker.md,
      pwsh/Catzc.Base.Docs/Add-SessionLearning.ps1,
    ]
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
- **Repeats stay (the user, 2026-10-21):** `Add-SessionLearning` skips only within-call duplicates, never a learning already in the log.
- Every session appends its own lines; lines relayed through another session are not kept in the log.
- **Decision round 2026-10-21, every recommendation taken:** the burst protocol (`hold` / `go`, `burst start` / `burst done`, no
  import-backed check during a hold) is two lines in `plans-orchestrate`, and its line 3 says a step left open names its check (Q8, Q9);
  `catzc-run` says a shared config is live for every session's next import (Q10); a peer's relayed lines are removed when it appends its own
  (Q11); the bootstrap comment page's `comment:18` shrinks to its first sentence and a link to `ADR-AUTO-TYPES-CHANGEDAFTERLOAD` when the
  page is next touched (Q12); `catzc-module` says an internal psm1 exports an explicit list, and names `Catzc.Base.CodeMeta` as the home of
  a shared head mechanism (Q13, Q15); `Test-IsRunningInVsCode` stays on `TERM_PROGRAM` until a session reports the mark missing (Q14); no
  session reads the log at start until it has filled for a week (Q16).

- **Delegated (the orchestrator, 2026-10-22):** the three simplifications from the orchestrator's finalize are taken (`catzc-module`,
  `plans-orchestrate`, the `plan-clear` deletion line).

## Open steps

- [ ] `.claude/learnings`: append catzc-49's "What I learned" lines, asked for on 2026-10-21, each rewritten to a current fact first; no
      copy is in the tree, `out/` or the orchestrator logs, and catzc-49 is not live, so the step waits on catzc-49 sending them (check:
      `Test-Markdownlint -Path '.claude/**/*.md'`).

## Open questions

- Proposals from catzc-a0's finalize (2026-10-22), each the user's to take or leave, none applied:
  - `.claude/skills/catzc-check/SKILL.md`, merged, the file kept at 10 lines: the decision-record gate is `Test-DrsRegistry` (registry-wide,
    no `-Path`), and `Test-Parsing -Path` takes files, never a folder.
  - `.claude/skills/catzc-verify/SKILL.md` step 1, merged: a new folder under `.claude/hooks` is an import-path change (every import builds
    each hook folder that has a csproj), so it is drafted outside the tree and lands in a burst.
  - The pwsh test page of ADR-AUTO-TEST, one sentence: index a function's result as `@(Get-X)[0]`, since a one-item result unrolls to the
    item and `(Get-X)[0]` indexes into a string.
- Proposals from catzc-e3's finalize (2026-10-22), each the user's to take or leave, none applied:
  - `.claude/skills/catzc-verify/SKILL.md`, merged, the file kept at 10 lines: a new or changed comment page re-imprints its source file
    with `Format-Code -Path`, since the code head's `docs:` and `cites:` derive from the page.
  - `.claude/skills/catzc-run/SKILL.md`, merged: commands handed from bash to `Invoke-CatzcCommand` go in single quotes, so bash leaves `$_`
    alone; a burst ends with "burst done" sent at once after `Exit-CatzcBurst`.
  - The `plan-debt-full-run-failures` text names `globs.yml` for the kind overlaps; they live in `file-kinds.yml`, one word to correct when
    the plan is next touched.
- From plan-debt-build-artifact-cause (deleted 2026-10-22, its step landed), the user's to take or leave: a writer's line ending in the
  capability. Recommended: one clause in `.claude/skills/catzc-verify/SKILL.md`, a Python file writer passes `newline="\n"`, since
  `Path.write_text` writes CRLF on Windows and Test-Formatting then fails the file. The alternative is a ruff or analyzer rule over
  `write_text(` calls, which costs a check but needs no reading.
