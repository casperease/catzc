---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: feature
  targets: [.claude/hooks, .claude/skills/catzc-run/SKILL.md]
---

# Session learnings: the forward-memory log the finalizer writes

`Add-SessionLearning` appends each session's "What I learned" lines to `.claude/learnings/`, a first-in, first-out log of `learned<sha>.md`
files (5 files of 50 learnings, declared on `LearningsConfig`), written to pass the markdown lint. Left: one finalize proposal, a "one
editor" claim for a shared config, which needs a hook of its own.

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

- [ ] `.claude/hooks` and `.claude/skills/catzc-run/SKILL.md`: a lock-only "one editor" claim for a shared config (`timeouts.yml`,
      `dependencies.yml`) while a session edits it (decided 2026-10-27, the coordinator). The run lock (`Local\catzc-run`, a named mutex
      `Wait-CatzcRunLock` takes) is released when its process exits, so it cannot span an edit across tool calls: the claim is a file-backed
      record (session, path, expiry within `run_lock.wait_seconds` roofs) the Edit hook checks, refusing another session's Edit of a claimed
      path and passing the claimant's; the new hook folder lands in a burst, since every import builds it (check: `Invoke-TestFile` on the
      hook's test file shows a second session's Edit of a claimed `timeouts.yml` denied and the claimant's allowed).
