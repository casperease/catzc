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

- [ ] `.claude/learnings`: append catzc-49's "What I learned" lines, asked for on 2026-10-21, each rewritten to a current fact first (check:
      `Test-Markdownlint -Path '.claude/**/*.md'`).

## Open questions

- Each session now appends its own lines, so the lines catzc-5b logged on seven peers' behalf (catzc-e8, -e2, -33, -03, -80, -59, -91) can
  double. Remove a peer's relayed lines when it appends its own (as done for catzc-4f), or remove all relayed lines now? Recommendation:
  when it appends its own.

- Should a session read the newest learnings file at start, at the cost of up to 50 lines of context? Recommendation: not yet; first let the
  log fill for a week and see which lines get reused.
- Should one cats command run one check in the background, so a check needs no throwaway `out/*.ps1`? It is the friction most sessions name.
  Recommendation: yes, as a `catzc-run` capability line backed by one command.
