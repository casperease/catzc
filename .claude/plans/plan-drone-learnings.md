---
plan:
  status: active
  value: low
  reviewed: 2026-10-25
  class: meta
  targets: [.claude/skills/catzc-verify/SKILL.md, docs/drs/repository/comments-in-docs.md]
---

# Drone learnings: three facts the next session rediscovers

A drone session on 2026-10-25 lost turns to three facts the tree states nowhere a writer looks first. Each proposal shrinks or moves one of
them to the place it is needed; none is applied until the user answers.

## Why its value is low

Nothing breaks without it; it saves a rerun or two per comment rollout module and per new PowerShell function.

## Open steps

## Open questions

- Should `docs/drs/repository/comments-in-docs.md` state, in its "Clues, not narration" section, that a new insight line never sits next to
  another comment line (two adjacent lines reach the export threshold and Export-Comments moves both) and that a page anchor is the code
  line cut at the last space before character 77 plus "..." when over 80? Recommendation: yes, one sentence each; today both are found only
  by a failed Test-Comments or a moved comment.
- Should the `catzc-verify` capability carry one line: "a whole-file comment goes on the type or function declaration, never above a using"?
  Recommendation: no; put it in the same `comments-in-docs.md` sentence instead, so the capability stays at its line roof.
- Should a how-to collect the three strict-mode traps that each cost a rerun here: an `if` expression yielding `@()` gives `$null`;
  `, $array` returned from a function counts as one item under `@()`; `.ForEach` on a .NET `List` binds `List<T>.ForEach(Action)`?
  Recommendation: yes, a short `docs/how-to/automation/strict-mode-traps.md`, linked from the strict-mode memory, not from CLAUDE.md.
