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
      .claude/agents/catzc-drone.md,
      pwsh/Base.Docs/Add-SessionLearning.ps1,
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

- From the orchestrator's finalize (2026-10-26), four shrink proposals, not applied: (1) `Get-TimeoutSeconds -Command` resolves a module's
  private function too, or refuses with "use -Executable", so the next private caller cannot throw at run time; (2) the `catzc-verify` skill
  gains one line, "a comment-only edit is proven by a diff showing only comment lines, never by a parse"; (3) `Invoke-StagedBurst` refuses a
  staged folder under `out/`, which the user clears by hand; (4) a lock-only "one editor" claim for a shared config (`timeouts.yml`,
  `dependencies.yml`) during a session's edit. Recommendation: yes to all four, each with its own check.
- From catzc-68's finalize (2026-10-26), three shrink proposals, not applied: (1) the `catzc-drone` brief pattern gains "write every file
  with the Edit tool; a script that writes files is refused", since three drones generated records by script and one dropped facts; (2)
  `catzc-verify` lists the glossary's family heads once (gate, scope, source, domain, layer, slot, zone), so a new heading avoids a G6 hit
  without a gate round; (3) a drone brief over more than about 15 records is split before spawning, since every such drone hit its 50-turn
  roof. Recommendation: yes to all three.

## Delegated (the orchestrator, 2026-10-22, on the user's "don't wait, go on")

- Every finalize proposal above is taken as one step; the `globs.yml` word in plan-debt-full-run-failures is already `file-kinds.yml` where
  it names the overlaps (line 26), so that proposal is dropped; the line-ending clause is taken as a capability line, not an analyzer rule.
