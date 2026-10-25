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
them to the place it is needed; the user decided each on 2026-10-25.

## Why its value is low

Nothing breaks without it; it saves a rerun or two per comment rollout module and per new PowerShell function.

## Open steps

- [ ] `docs/drs/repository/comments-in-docs.md`, "Clues, not narration": three sentences. A new insight line never sits next to another
      comment line (two adjacent lines reach the export threshold and Export-Comments moves both); a page anchor is the code line cut at the
      last space before character 77 plus "..." when over 80; a whole-file comment goes on the type or function declaration, never above a
      using. `catzc-verify` stays unchanged (check: `Test-Links` and `Test-Comments` on the page).
- [ ] `docs/how-to/automation/strict-mode-traps.md`: the three traps (an `if` expression yielding `@()` gives `$null`; `, $array` returned
      from a function counts as one item under `@()`; `.ForEach` on a .NET `List` binds `List<T>.ForEach(Action)`), linked from the
      strict-mode memory and not from CLAUDE.md (check: `Test-Links` on the page).
